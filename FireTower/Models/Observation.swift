//
//  Observation.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation

struct Observation: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var heading: Double
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var locationAccuracy: Double
    var headingAccuracy: Double
    
    init(
        name: String,
        heading: Double,
        latitude: Double,
        longitude: Double,
        locationAccuracy: Double,
        headingAccuracy: Double
    ) {
        self.id = UUID()
        self.name = name
        self.heading = heading
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = Date()
        self.locationAccuracy = locationAccuracy
        self.headingAccuracy = headingAccuracy
    }
}

extension Observation {
    static var preview: Observation {
        Observation(
            name: "O1",
            heading: 73.2,
            latitude: 44.9778,
            longitude: -93.2650,
            locationAccuracy: 5.0,
            headingAccuracy: 9.8
        )
    }

    static var preview2: Observation {
        Observation(
            name: "O2",
            heading: 128.5,
            latitude: 44.9833,
            longitude: -93.2667,
            locationAccuracy: 4.0,
            headingAccuracy: 10.2
        )
    }
    
    static var previewList = [Observation.preview, Observation.preview2]
}
