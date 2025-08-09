//
//  MainTabView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var sightingStore = SightingStore()
    
    var body: some View {
        TabView {
            SightingsListView(store: sightingStore)
                .tabItem {
                    Label("Sightings", systemImage: "binoculars.fill")
                }

            CompassMapContainerView(locationManager: locationManager)
                .tabItem {
                    Label("Compass/Map", systemImage: "arrowshape.up")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .onAppear {
            locationManager.requestLocationIfNeeded()
        }
    }
}

#Preview {
    MainTabView()
}
