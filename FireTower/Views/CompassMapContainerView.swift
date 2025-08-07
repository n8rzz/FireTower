//
//  CompassMapContainerView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI

struct CompassMapContainerView: View {
    @State private var shouldShowMap = false
    
    func createRandomObservation() -> Observation {
        return Observation(
            name: "O\(Int.random(in: 1...100))",
            heading: Double.random(in: 0...359),
            latitude: Double.random(in: 37.0...38.0),
            longitude: Double.random(in: (-123.0)...(-122.0)),
            locationAccuracy: Double.random(in: 5...30),
            headingAccuracy: Double.random(in: 0...15)
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HeadingAccuracyWarningView()
                
                Spacer()
                
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 8)
                    .frame(width: 300, height: 300)
                    .overlay(Text("Compass").foregroundColor(Theme.Colors.TextPrimary))

                Spacer()
                
                Button(action: {
                    let capturedObservation = createRandomObservation()
                    print("Simulated observation captured", capturedObservation)
                }) {
                    HStack {
                        Text("Capture")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.Colors.Secondary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
            Button("Show Map") {
                    shouldShowMap.toggle()
                }
                .font(.subheadline)
                .padding(.top, 10)
                Spacer()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Compass")
        }
        .sheet(isPresented: $shouldShowMap) {
            VStack {
                Spacer()
                
                Text("Map View (Placeholder)")
                    .font(.title)
                    .padding()
                
                Spacer()
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    CompassMapContainerView()
        .environmentObject(LocationManager.mockPreview)
}
