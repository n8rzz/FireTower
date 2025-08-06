//
//  SettingsView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Settings")
                Spacer()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
