//
//  ObservationSet.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation

struct ObservationSet: Identifiable, Codable {
    var id: UUID
    var name: String
    var dateCreated: Date
    var observations: [Observation]
    
    init(
        name: String,
        observations: [Observation] = []
    ) {
        self.id = UUID()
        self.name = name
        self.dateCreated = Date()
        self.observations = observations
    }
}

extension ObservationSet {
    static var preview: ObservationSet {
        ObservationSet(
            name: "Demo Fire",
            observations: [
                .preview,
                .preview2
            ]
        )
    }

    static var empty: ObservationSet {
        ObservationSet(name: "Empty Fire")
    }
}
