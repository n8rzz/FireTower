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
        manager.location = CLLocation(latitude: 44.9778, longitude: -93.2650)
        return manager
    }
}
