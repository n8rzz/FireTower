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
            Text("Compass + Map View")
                .navigationTitle("Compass")
            
            HeadingAccuracyWarningView()
        }
    }
}

#Preview {
    CompassMapContainerView()
        .environmentObject(LocationManager.mockPreview)
}
