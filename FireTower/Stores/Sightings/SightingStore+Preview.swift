//
//  SightingStore+Preview.swift
//  FireTower
//
//  Created by Nate Geslin on 8/7/25.
//

import Foundation

extension SightingStore {
    static var preview: SightingStore {
        let store = SightingStore()
        let obs1 = Observation(
            name: "O1",
            heading: 45,
            latitude: 37.7749,
            longitude: -122.4194,
            locationAccuracy: 5,
            headingAccuracy: 3,
            elevation: 100,
            angle: 15
        )

        let obs2 = Observation(
            name: "O2",
            heading: 60,
            latitude: 37.7750,
            longitude: -122.4195,
            locationAccuracy: 4,
            headingAccuracy: 2,
            elevation: 95,
            angle: 12
        )

        store.sightings = [
            Sighting(name: "North Ridge Smoke", observations: [obs1]),
            Sighting(name: "Lakeview Fire", observations: [obs1, obs2])
        ]

        return store
    }
}
