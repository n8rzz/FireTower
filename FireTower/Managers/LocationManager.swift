//
//  LocationManager.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import CoreLocation
import CoreMotion
import Combine

enum HeadingSource: String {
    case `true`
    case magnetic
    case unknown
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let motion = CMMotionManager()

    // MARK: - Published state
    @Published var location: CLLocation?
    @Published var heading: CLHeading?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    @Published var locationAccuracy: CLLocationAccuracy = -1
    @Published var headingAccuracy: CLLocationDirection = -1

    @Published var headingDegrees: Double = 0
    @Published var headingSource: HeadingSource = .unknown
    @Published var headingDegreesContinuous: Double = 0
    @Published var headingDegreesDisplay: Double = 0

    @Published var tiltDegrees: Double = 0
    @Published var isFlat: Bool = true
    @Published var needsCalibrationHint: Bool = false
    
    // MARK: - Config
    // --- Smoothing config/state ---
    private let alpha: Double = 0.50    // low‑pass (0..1). Higher = snappier
    private let deadband: Double = 0.3  // ignore micro jitter (< this many degrees)
    private var hasFilter: Bool = false
    private var lastRaw: Double = 0
    private var smoothed: Double = 0
    /// Flatness threshold in degrees; user can still capture when not flat (warning only)
    private let flatnessThreshold: Double = 20
    /// UX hint threshold for "low compass accuracy"
    private let poorHeadingAccuracyThreshold: Double = 12
    /// Motion update interval
    private let motionUpdateInterval: TimeInterval = 1.0 / 30.0
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.headingFilter = kCLHeadingFilterNone
        manager.distanceFilter = 1
        manager.requestWhenInUseAuthorization()

        // Start right away so previews/screens show data; we'll add explicit lifecycle controls too.
        startUpdates()
    }
    
    func startUpdates() {
        // Location + heading
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()

        // Motion (tilt/flatness)
        startMotionUpdates()
    }

    func stopUpdates() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        motion.stopDeviceMotionUpdates()
    }

    // MARK: - CoreMotion
    private func startMotionUpdates() {
        guard motion.isDeviceMotionAvailable else { return }
        motion.deviceMotionUpdateInterval = motionUpdateInterval

        // We only need tilt relative to gravity; magnetic frame isn’t required for that.
        motion.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] dm, _ in
            guard let self, let dm = dm else { return }
            // Gravity vector components (g ~ 1.0)
            let gz = dm.gravity.z
            // Tilt from flat plane: 0° = perfectly flat, 90° = upright
            // When flat (screen-up), |gz| ≈ 1.0 → acos(|gz|) ≈ 0°
            let clamped = max(-1.0, min(1.0, gz))
            let tiltRad = acos(abs(clamped))
            let tiltDeg = tiltRad * 180.0 / .pi
            self.tiltDegrees = tiltDeg
            self.isFlat = tiltDeg <= self.flatnessThreshold
        }
    }

    @MainActor
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            // Ensure we’re running if granted while app is active
            startUpdates()
        }
    }

    @MainActor
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        locationAccuracy = locations.last?.horizontalAccuracy ?? -1
    }

    @MainActor
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading
        headingAccuracy = newHeading.headingAccuracy

        // Prefer true heading; fallback to magnetic
        let usingTrue = newHeading.trueHeading >= 0
        let raw = usingTrue
            ? LocationManager.normalizeDegrees(newHeading.trueHeading)
            : LocationManager.normalizeDegrees(newHeading.magneticHeading)

        headingSource = usingTrue ? .true : .magnetic
        headingDegrees = raw  // raw, normalized 0..360 (for any legacy uses)

        processHeading(raw: raw)

        needsCalibrationHint = headingAccuracy < 0 || headingAccuracy > poorHeadingAccuracyThreshold
    }

    @MainActor
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        // Always allow calibration prompt if needed
        return true 
    }
    
    static func normalizeDegrees(_ deg: CLLocationDirection) -> Double {
        var value = deg.truncatingRemainder(dividingBy: 360)
        if value < 0 { value += 360 }
        return value
    }
    
    func requestLocationIfNeeded() {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    private func processHeading(raw: Double) {
        if !hasFilter {
            hasFilter = true
            lastRaw = raw
            smoothed = raw
            headingDegreesContinuous = raw
            headingDegreesDisplay = raw
            return
        }

        // shortest delta in (-180, +180]
        var delta = raw - lastRaw
        if delta > 180 { delta -= 360 }
        if delta <= -180 { delta += 360 }

        // ignore tiny jitter
        if abs(delta) < deadband { delta = 0 }

        // build a continuous angle (can exceed 360 / go negative)
        let continuous = headingDegreesContinuous + delta

        // low-pass filter
        let s = alpha * continuous + (1 - alpha) * smoothed
        smoothed = s

        // publish
        headingDegreesContinuous = s
        headingDegreesDisplay = LocationManager.normalizeDegrees(s)
        lastRaw = raw
    }
}

