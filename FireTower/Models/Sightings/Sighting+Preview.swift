//
//  SightingStore+Preview.swift
//  FireTower
//
//  Created by Nate Geslin on 8/7/25.
//

import Foundation

extension Sighting {
    static var preview: Sighting {
        Sighting(
            name: "Demo Fire",
            observations: [
                .preview,
                .preview2
            ]
        )
    }

    static var empty: Sighting {
        Sighting(name: "Empty Fire")
    }
}
