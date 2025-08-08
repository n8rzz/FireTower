//
//  SightingStore.swift
//  FireTower
//
//  Created by Nate Geslin on 8/7/25.
//

import Foundation
import Combine

final class SightingStore: ObservableObject, SightingStoreProtocol {
    @Published var sightings: [Sighting] = []
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        load()
        
        $sightings
            .dropFirst()
            .sink { [weak self] _ in self?.save() }
            .store(in: &cancellables)
    }
    
    func add(_ sighting: Sighting) {
        sightings.append(sighting)
    }
    
    func update(_ sighting: Sighting) {
        guard let index = sightings.firstIndex(where: { $0.id == sighting.id }) else { return }
        sightings[index] = sighting
    }

    func delete(_ sighting: Sighting) {
        sightings.removeAll { $0.id == sighting.id }
    }

    func load() {
        do {
            let data = try Data(contentsOf: sightingsFileURL)
            let decoded = try JSONDecoder().decode([Sighting].self, from: data)
            
            sightings = decoded
        } catch {
            print("Failed to load sightings: \(error)")
            
            sightings = []
        }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(sightings)
            
            try data.write(to: sightingsFileURL, options: [.atomic])
        } catch {
            print("Failed to save sightings: \(error)")
        }
    }
}

// MARK: - File Url

private var sightingsFileURL: URL{
    let manager = FileManager.default
    let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
    
    return urls[0].appendingPathComponent("sightings.json")
}
