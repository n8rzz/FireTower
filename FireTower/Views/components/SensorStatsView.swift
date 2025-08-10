//
//  SensorStatsView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/8/25.
//

import Foundation
import SwiftUI

struct SensorStatsView: View {
    @ObservedObject var locationManager: LocationManager

//    private var headingLabel: String {
//        String(format: "%.0f°", locationManager.headingDegrees)
//    }
//
//    private var headingSourceLabel: String {
//        switch locationManager.headingSource {
//        case .true: return "True"
//        case .magnetic: return "Mag"
//        case .unknown: return "—"
//        }
//    }
//
//    private var headingAccLabel: String {
//        guard locationManager.headingAccuracy >= 0 else { return "—" }
//        return String(format: "±%.0f°", locationManager.headingAccuracy)
//    }

    private var latLabel: String {
        if let loc = locationManager.location {
            return String(format: "%.5f", loc.coordinate.latitude)
        }
        return "—"
    }

    private var lonLabel: String {
        if let loc = locationManager.location {
            return String(format: "%.5f", loc.coordinate.longitude)
        }
        return "—"
    }

    private var gpsAccLabel: String {
        guard locationManager.locationAccuracy >= 0 else { return "—" }
        return String(format: "±%.0fm", locationManager.locationAccuracy)
    }

    private var tiltLabel: String {
        String(format: "%.0f°", locationManager.tiltDegrees)
    }

    private var flatnessLabel: String {
        locationManager.isFlat ? "Flat" : "Tilted"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Label("Heading", systemImage: "location.north")
//                Spacer()
//                Text("\(headingLabel) (\(headingSourceLabel))")
//                    .font(.callout).monospacedDigit()
//            }

//            HStack {
//                Text("Heading Acc")
//                Spacer()
//                Text(headingAccLabel)
//                    .font(.callout).monospacedDigit()
//            }

            HStack {
                Label("Position", systemImage: "mappin.and.ellipse")
                Spacer()
                Text("Lat \(latLabel)  Lon \(lonLabel)")
                    .font(.callout).monospacedDigit()
            }

            HStack {
                Text("GPS Acc")
                Spacer()
                Text(gpsAccLabel)
                    .font(.callout).monospacedDigit()
            }

            HStack {
                Label("Tilt", systemImage: "iphone")
                Spacer()
                Text("\(tiltLabel)  •  \(flatnessLabel)")
                    .font(.callout).monospacedDigit()
            }
        }
        .padding(12)
        .background(Theme.Colors.Surface.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
