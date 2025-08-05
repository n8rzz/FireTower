//
//  FireTowerApp.swift
//  FireTower
//
//  Created by Nate Geslin on 8/4/25.
//

import SwiftUI

@main
struct FireTowerApp: App {
    @StateObject private var observationStore = ObservationStore()

    var body: some Scene {
        WindowGroup {
            ObservationSetListView()
                .environmentObject(observationStore)
        }
    }
}
