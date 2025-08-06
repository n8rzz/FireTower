//
//  CompassMapContainerView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI

struct CompassMapContainerView: View {
    var body: some View {
        NavigationView {
            VStack {
                HeadingAccuracyWarningView()
                
                Spacer()
                Text("Compass + Map View")
                Spacer()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Compass")
        }
    }
}

#Preview {
    CompassMapContainerView()
        .environmentObject(LocationManager.mockPreview)
}
