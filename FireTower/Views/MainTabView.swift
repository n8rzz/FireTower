//
//  MainTabView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var observationStore: ObservationStore
    @EnvironmentObject private var locationManager: LocationManager
    
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
        .ignoresSafeArea(.all, edges: .all)
    }
}

#Preview {
    MainTabView()
}
