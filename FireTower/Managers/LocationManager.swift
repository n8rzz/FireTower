//
//  LocationManager.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var heading: CLHeading?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationAccuracy: CLLocationAccuracy = -1
    @Published var headingAccuracy: CLLocationDirection = -1

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.headingFilter = kCLHeadingFilterNone
        manager.distanceFilter = 1
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    @MainActor
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
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
    }

    @MainActor
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        // Always allow calibration prompt if needed
        return true 
    }
    
    func requestLocationIfNeeded() {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}

