//
//  SightingStoreProtocol.swift
//  FireTower
//
//  Created by Nate Geslin on 8/7/25.
//

import Foundation

protocol SightingStoreProtocol: AnyObject {
    var sightings: [Sighting] {get set}
    func add(_ sighting: Sighting)
    func update(_ sighting: Sighting)
    func delete(_ sighting: Sighting)
    func load()
    func save()
}
