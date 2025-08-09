//
//  LocationManager+Preview.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import CoreLocation

extension LocationManager {
    static var preview: LocationManager {
        let manager = LocationManager()
        // Simulate some values
        manager.headingDegrees = Double.random(in: 0..<360)
        manager.headingAccuracy = Double.random(in: 5...25)
        manager.locationAccuracy = Double.random(in: 5...50)
        manager.headingSource = Bool.random() ? .true : .magnetic
        manager.tiltDegrees = Double.random(in: 0...35)
        manager.isFlat = manager.tiltDegrees <= 20
        manager.needsCalibrationHint = manager.headingAccuracy > 12
        return manager
    }
}
