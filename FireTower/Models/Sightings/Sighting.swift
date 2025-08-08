//
//  ObservationSet.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation

struct Sighting: Identifiable, Codable, Equatable {
    static func == (lhs: Sighting, rhs: Sighting) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var name: String
    var observations: [Observation]
    var createdAt: Date
    var updatedAt: Date
    
    static let maxObservationCount = 5
    
    init(
        name: String,
        observations: [Observation] = []
    ) {
        self.id = UUID()
        self.name = name
        self.observations = observations
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func addObservation(_ observation: Observation) {
        guard observations.count < Self.maxObservationCount else { return }
        
        observations.append(observation)
        updatedAt = Date()
    }
    
    mutating func updateObsevration(_ observation: Observation) {
        guard let index = observations.firstIndex(where: { $0.id == observation.id }) else { return }
        observations[index] = observation
        updatedAt = Date()
    }
    
    mutating func deleteObservation(_ observation: Observation) {
        observations.removeAll { $0.id == observation.id }
        updatedAt = Date()
    }
}

