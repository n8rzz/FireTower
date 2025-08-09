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
    @Published var tiltDegrees: Double = 0
    @Published var isFlat: Bool = true
    @Published var needsCalibrationHint: Bool = false
    
    // MARK: - Config
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

        // Prefer true heading when valid; else use magnetic
        let usingTrue = newHeading.trueHeading >= 0   // per Apple docs, -1 means invalid
        if usingTrue {
            headingDegrees = LocationManager.normalizeDegrees(newHeading.trueHeading)
            headingSource = .true
        } else {
            headingDegrees = LocationManager.normalizeDegrees(newHeading.magneticHeading)
            headingSource = .magnetic
        }

        // Simple heuristic for a calibration UX hint
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
}

