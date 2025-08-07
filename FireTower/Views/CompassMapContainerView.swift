//
//  CompassMapContainerView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI

struct CompassMapContainerView: View {
    @State private var lastCapturedObservation: Observation?
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
                                
                // TODO: abstract?
                // Compass
                ZStack {
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 8)
                        .frame(width: 350, height: 350)
                    
                    ArrowView(shaftHeight: 305.00)
                }
                .padding(.vertical)
                
                Button(action: {
                    let capturedObservation = createRandomObservation()
                    lastCapturedObservation = capturedObservation
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
                
                if let obs = lastCapturedObservation {
                    VStack(spacing: 4) {
                        HStack {
                            Text(String(format: "Lat: %.5f", obs.latitude))
                            Text(String(format: "Lat: %.5f", obs.longitude))
                        }
//                        Text(String(format: "Elevation: %.0f m", obs.elevation))
                        Text("Elevation: n/a")
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.top, 5)
                }
                
                Spacer()
                    .ignoresSafeArea()
                
                Button("Show Map") {
                    shouldShowMap.toggle()
                }
                .font(.subheadline)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(Color(.systemBackground))
            .navigationTitle("TITLE")
        }
        .sheet(isPresented: $shouldShowMap) {
            VStack {
                Spacer()
                
                Text("Observations (3)")
                    .font(.title)
                    .padding()
                
                Rectangle()
                    .foregroundColor(.gray)
                    .padding()
                    .cornerRadius(10)
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    CompassMapContainerView()
        .environmentObject(LocationManager.mockPreview)
}
