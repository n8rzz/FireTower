//
//  HeadingAccuracyWarningView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import SwiftUI

struct HeadingAccuracyWarningView: View {
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        if locationManager.headingAccuracy > 25 {
            HStack(spacing: 12) {
                Image(systemName: "location.north.line")
                VStack(alignment: .leading) {
                    Text("Compass accuracy is low")
                        .font(.headline)
                    Text("Try moving your phone in a figure-eight motion.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.orange.opacity(0.15))
            .cornerRadius(12)
            .padding([.horizontal, .top])
        }
    }
}

extension LocationManager {
    static var mockPreview: LocationManager {
        let manager = LocationManager()
        manager.headingAccuracy = Double.random(in: 0...30)
        return manager
    }
}
