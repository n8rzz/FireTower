//
//  PermissionPromptView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import SwiftUI
import CoreLocation

struct PermissionPromptView: View {
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        VStack(spacing: 16) {
            if locationManager.authorizationStatus == .denied {
                Label("Location access denied", systemImage: "location.slash")
                Text("Please enable location access in Settings.")
            } else if locationManager.authorizationStatus == .notDetermined {
                Label("Requesting location permission…", systemImage: "location")
            } else {
                EmptyView()
            }
        }
        .padding()
        .foregroundColor(.red)
    }
}

