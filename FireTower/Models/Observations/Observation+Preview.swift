//
//  Observation+Preview.swift
//  FireTower
//
//  Created by Nate Geslin on 8/7/25.
//

import Foundation

extension Observation {
    static var preview: Observation {
        Observation(
            name: "O\(UUID())",
            heading: Double.random(in: 0..<360),
            latitude: 37.7749 + Double.random(in: -0.01...0.01),
            longitude: -122.4194 + Double.random(in: -0.01...0.01),
            locationAccuracy: Double.random(in: 3...10),
            headingAccuracy: Double.random(in: 1...5),
            elevation: Double.random(in: 90...110),
            angle: Double.random(in: 10...20)
        )
    }

    static var preview2: Observation {
        Observation(
            name: "O\(UUID())",
            heading: Double.random(in: 0..<360),
            latitude: 37.7749 + Double.random(in: -0.01...0.01),
            longitude: -122.4194 + Double.random(in: -0.01...0.01),
            locationAccuracy: Double.random(in: 3...10),
            headingAccuracy: Double.random(in: 1...5),
            elevation: Double.random(in: 90...110),
            angle: Double.random(in: 10...20)
        )
    }
    
    static var previewList = [Observation.preview, Observation.preview2]
}
