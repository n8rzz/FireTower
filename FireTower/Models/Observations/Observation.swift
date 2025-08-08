//
//  Observation.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import CoreLocation

struct Observation: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var heading: Double
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var locationAccuracy: CLLocationAccuracy
    var headingAccuracy: CLLocationDirectionAccuracy
    var elevation: Double? = nil
    var angle: Double? = nil
    
    init(
        name: String,
        heading: Double,
        latitude: Double,
        longitude: Double,
        locationAccuracy: Double,
        headingAccuracy: Double,
        elevation: Double?,
        angle: Double?
    ) {
        self.id = UUID()
        self.name = name
        self.heading = heading
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = Date()
        self.locationAccuracy = locationAccuracy
        self.headingAccuracy = headingAccuracy
        self.elevation = elevation
        self.angle = angle
    }
}
