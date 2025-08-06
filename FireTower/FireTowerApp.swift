//
//  FireTowerApp.swift
//  FireTower
//
//  Created by Nate Geslin on 8/4/25.
//

import SwiftUI

@main
struct FireTowerApp: App {
    @State private var shouldShowLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            if shouldShowLaunchScreen {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            shouldShowLaunchScreen = false
                        }
                    }
            } else {
                MainTabView()
            }
        }
    }
}
