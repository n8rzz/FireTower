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
    @State private var shouldShowToast = false
    @State private var toastMessage = ""
    
    private var observationCount: Int { sighting?.observations.count ?? 0 }
    private var isAtMaximumObservations: Bool { observationCount >= Sighting.maxObservationCount}
    
    private var sighting: Sighting? {
        guard let sightingID = activeSightingID else { return nil }
        return store.sightings.first(where: { $0.id == sightingID })
    }
    
    private var headingBadgeText: String {
        guard locationManager.heading != nil else { return "---" }
        let value = Int(round(locationManager.headingDegrees))
        return "\(value)"
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
        List {
            HeadingAccuracyWarningView(locationManager: locationManager)
            
            HeadingBadge(text: headingBadgeText)
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            
            // TODO: abstract?
            // MARK: - Compass
            ZStack {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 8)
                    .frame(width: 350, height: 350)

                ArrowView(shaftHeight: 305.0)
            }
            .padding(.top, 5)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            
            // MARK: - Capture
            HStack {
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
                    toastMessage = "Captured \(observationToCreate.name)"
                    withAnimation { shouldShowToast = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { shouldShowToast = false }
                    }
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
            }
            .padding(.horizontal, 16)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            
            if isAtMaximumObservations {
                Text("Maximum of \(Sighting.maxObservationCount) observations reached")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 2)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            
//            SensorStatsView(locationManager: locationManager)
//                .listRowInsets(EdgeInsets())
//                .listRowSeparator(.hidden)
//                .listRowBackground(Color.clear)
            
            // MARK - Observations
            if let s = sighting {
                Section(
                    header: Text("Observations (\(s.observations.count)/\(Sighting.maxObservationCount))"),
                    footer: isAtMaximumObservations
                        ? Text("Maximum of \(Sighting.maxObservationCount) observations reached.")
                            .foregroundColor(.secondary)
                        : nil
                ) {
                    if s.observations.isEmpty {
                        Text("No observations yet")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(s.observations) { obs in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(obs.name).font(.headline)
                                Text("Heading: \(Int(obs.heading))°")
                                Text("Location: \(obs.latitude), \(obs.longitude)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete(perform: deleteObservation)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .listStyle(.insetGrouped)
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
        .overlay(alignment: .top) {
            if shouldShowToast {
                ToastBanner(text: toastMessage)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 8)
                
            }
        }
        .sheet(isPresented: $shouldShowMap) {
            VStack {
                Spacer()
                
                Text("Observations (\(sighting?.observations.count ?? 0))")
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
    NavigationStack {
        CompassMapContainerView(
            id: Sighting.preview.id,
            store: .preview,
            locationManager: .preview
        )
    }
}
