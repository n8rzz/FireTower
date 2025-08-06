//
//  MainTabView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @StateObject private var observationStore = ObservationStore()

    var body: some View {
        TabView {
            ObservationSetListView()
                .environmentObject(observationStore)
                .tabItem {
                    Label("Observations", systemImage: "list.bullet")
                }
            
            CompassMapContainerView()
                .tabItem {
                    Label("Compass/Map", systemImage: "location.north.line.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    MainTabView()
}
