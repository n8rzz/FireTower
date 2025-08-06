//
//  CompassView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI

struct CompassView: View {
    var body: some View {
        Text("Compass View")
        
        HeadingAccuracyWarningView()
    }
}

#Preview {
    CompassView()
        .environmentObject(LocationManager.mockPreview)
}
