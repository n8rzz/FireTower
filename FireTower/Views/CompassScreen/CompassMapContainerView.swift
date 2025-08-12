//
//  CompassMapContainerView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI
import UIKit

struct CompassMapContainerView: View {
    let id: UUID?
    @ObservedObject var store: SightingStore
    @ObservedObject var locationManager: LocationManager
    
    @State private var activeSightingID: UUID?
    @State private var lastCapturedObservation: Observation?
    @State private var shouldShowMap = false
    
    private var observationCount: Int { sighting?.observations.count ?? 0 }
    private var isAtMaximumObservations: Bool { observationCount >= Sighting.maxObservationCount}
    
    private var sighting: Sighting? {
        guard let sightingID = activeSightingID else { return nil }
        return store.sightings.first(where: { $0.id == sightingID })
    }
    
    private var headingSourceLabel: String {
        switch locationManager.headingSource {
            case .true: return "True"
            case .magnetic: return "Mag"
            case .unknown: return "—"
        }
    }
        
    init(
        id: UUID? = nil,
        store: SightingStore,
        locationManager: LocationManager
    ) {
        self.id = id
        self.store = store
        self.locationManager = locationManager
    }
    
    func createRandomObservation() -> Observation {
        return Observation.preview
    }

    private func autoName(for count: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm" // or "HH:mm" if you prefer a colon
        return formatter.string(from: Date())
    }
    
    private func buildObservation() -> Observation? {
        guard let currentLocation = locationManager.location else { return nil }
        
        return Observation(
            name: autoName(for: observationCount),
            heading: locationManager.headingDegrees,
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude,
            locationAccuracy: locationManager.locationAccuracy,
            headingAccuracy: locationManager.headingAccuracy,
            elevation: nil,
            angle: nil
        )
    }
    
    private func deleteObservation(at offsets: IndexSet) {
        guard var current = sighting else { return }
        for index in offsets {
            let toDelete = current.observations[index]
            current.deleteObservation(toDelete)
        }
        store.update(current)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Compass Section
            VStack(spacing: 24) {
                HeadingAccuracyWarningView(locationManager: locationManager)
                
                let liveHeading = locationManager.headingDegrees

                CompassHeader(
                    headingDegrees: liveHeading,
                    headingSourceText: headingSourceLabel,
                    accent: .primary
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            Spacer(minLength: 90)
            
            // MARK: - Capture Section
            VStack(spacing: 16) {
                Button(action: {
                    if activeSightingID == nil {
                        let sightingName = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
                        let newSighting = Sighting(name: sightingName)
                        store.add(newSighting)
                        activeSightingID = newSighting.id
                    }

                    guard var current = sighting else { return }
                    guard let observationToCreate = buildObservation() else {
                        print("Capture skipped: missing location/heading")
                        return
                    }

                    current.addObservation(observationToCreate)
                    store.update(current)
                    lastCapturedObservation = observationToCreate

                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                }) {
                    Text("Capture")
                        .font(.headline)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(Theme.Colors.Secondary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(isAtMaximumObservations)
                .padding(.horizontal, 16)
                
                if isAtMaximumObservations {
                    Text("Maximum of \(Sighting.maxObservationCount) observations reached")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
            Spacer(minLength: 24)
            
            // MARK: - Observations Section
            if let s = sighting {
                ObservationsSection(
                    observations: s.observations,
                    maxCount: Sighting.maxObservationCount,
                    onDelete: deleteObservation
                )
            }
            
            Spacer(minLength: 16)
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
        .navigationTitle(sighting?.name ?? "New Sighting")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    shouldShowMap = true
                } label: {
                    Image(systemName: "map")
                }
                .accessibilityLabel("Show Map")
            }
        }
        .onAppear {
            if activeSightingID == nil {
                activeSightingID = id
            }
        }
        .sheet(isPresented: $shouldShowMap) {
            VStack {
                if let s = sighting {
                    NavigationView {
                        SightingMapView(sighting: s)
                    }
                } else {
                    Text("No observations for sighting")
                        .padding()
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    NavigationStack {
        CompassMapContainerView(
            id: Sighting.preview.id,
            store: .preview,
            locationManager: .preview
        )
    }
}
