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
    @StateObject private var observationStore = ObservationStore()
    
    var body: some View {
        TabView {
            ObservationSetListView()
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
        .environmentObject(locationManager)
        .environmentObject(observationStore)
        .onAppear {
            locationManager.requestLocationIfNeeded()
        }
    }
}

#Preview {
    MainTabView()
}
