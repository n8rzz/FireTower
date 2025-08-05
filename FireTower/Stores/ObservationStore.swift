//
//  ObservationStore.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import Combine

@MainActor
class ObservationStore: ObservableObject {
    @Published var sets: [ObservationSet] = []

    private let saveURL: URL

    init(filename: String = "observation_sets.json") {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.saveURL = documentsDirectory.appendingPathComponent(filename)

        load()
    }

    func load() {
        guard FileManager.default.fileExists(atPath: saveURL.path) else { return }

        do {
            let data = try Data(contentsOf: saveURL)
            let decoded = try JSONDecoder().decode([ObservationSet].self, from: data)
            sets = decoded
        } catch {
            print("Failed to load observation sets: \(error)")
        }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(sets)
            try data.write(to: saveURL, options: [.atomicWrite])
        } catch {
            print("Failed to save observation sets: \(error)")
        }
    }

    func addObservationSet(named name: String) {
        sets.append(ObservationSet(name: name))
        save()
    }

    func deleteSet(_ set: ObservationSet) {
        sets.removeAll { $0.id == set.id }
        save()
    }

    func addObservation(to set: ObservationSet, observation: Observation) {
        if let index = sets.firstIndex(where: { $0.id == set.id }) {
            sets[index].observations.append(observation)
            save()
        }
    }

    func deleteObservation(setID: UUID, observationID: UUID) {
        guard let setIndex = sets.firstIndex(where: { $0.id == setID }) else { return }
        sets[setIndex].observations.removeAll { $0.id == observationID }
        save()
    }
}

extension ObservationStore {
    static var preview: ObservationStore {
        let store = ObservationStore()
        store.sets = [
            ObservationSet(
                name: "Sample Fire A",
                observations: [
                    Observation(name: "O1", heading: 45.0, latitude: 44.9778, longitude: -93.2650, locationAccuracy: 5.0, headingAccuracy: 10.0),
                    Observation(name: "O2", heading: 90.0, latitude: 44.9833, longitude: -93.2667, locationAccuracy: 4.5, headingAccuracy: 8.0)
                ]
            ),
            ObservationSet(
                name: "Sample Fire B",
                observations: [
                    Observation(name: "O1", heading: 120.0, latitude: 44.95, longitude: -93.3, locationAccuracy: 6.0, headingAccuracy: 12.0)
                ]
            )
        ]
        return store
    }
}
