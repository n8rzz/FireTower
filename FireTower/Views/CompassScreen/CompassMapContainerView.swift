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
    private var isAtMaximumObservations: Bool { observationCount >= Sighting.maxObservationCount }

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

    private func autoName(for count: Int) -> String {
        let f = DateFormatter()
        f.dateFormat = "HHmm"
        return f.string(from: Date())
    }

    private func buildObservation() -> Observation? {
        guard let loc = locationManager.location else { return nil }
        return Observation(
            name: autoName(for: observationCount),
            heading: locationManager.headingDegrees,
            latitude: loc.coordinate.latitude,
            longitude: loc.coordinate.longitude,
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
            // MARK: Compass Section
            Section {
                VStack(spacing: 24) {
                    HeadingAccuracyWarningView(locationManager: locationManager)

                    let liveHeading = locationManager.headingDegreesContinuous
                    let liveHeadingDisplay = locationManager.headingDegreesDisplay.rounded()
                    CompassHeader(
                        headingDegrees: liveHeading,
                        headingDegreesDisplay: liveHeadingDisplay,
                        headingSourceText: headingSourceLabel,
                        accent: .primary
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }

            // MARK: Capture Section
            Section {
                VStack(spacing: 8) {
                    Button {
                        if activeSightingID == nil {
                            let name = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
                            let newSighting = Sighting(name: name)
                            store.add(newSighting)
                            activeSightingID = newSighting.id
                        }

                        guard var current = sighting else { return }
                        guard let obs = buildObservation() else { return }

                        current.addObservation(obs)
                        store.update(current)
                        lastCapturedObservation = obs
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    } label: {
                        Text("Capture")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .disabled(isAtMaximumObservations)
                    .background(Theme.Colors.Secondary)
                    .foregroundColor(.white)
                    .cornerRadius(12)

                    if isAtMaximumObservations {
                        Text("Maximum of \(Sighting.maxObservationCount) observations reached")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.top, 70)
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 4, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }

            // MARK: Observations Section
            if let s = sighting {
                Section {
                    if s.observations.isEmpty {
                        Text("No observations yet")
                            .foregroundColor(.secondary)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(s.observations) { obs in
                            // Card content
                            VStack(alignment: .leading, spacing: 4) {
                                Text(obs.name).font(.headline)
                                Text("Heading: \(Int(obs.heading))°")
                                Text("Location: \(obs.latitude), \(obs.longitude)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(12) // internal card padding
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray6))
                            )
                            .contentShape(Rectangle())
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteObservation)
                    }
                } header: {
                    Text("Observations (\(s.observations.count)/\(Sighting.maxObservationCount))")
                        .font(.headline)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
        .navigationTitle(sighting?.name ?? "New Sighting")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    shouldShowMap = true
                } label: { Image(systemName: "map") }
                .accessibilityLabel("Show Map")
            }
        }
        .onAppear {
            if activeSightingID == nil { activeSightingID = id }
        }
        .sheet(isPresented: $shouldShowMap) {
            VStack {
                if let s = sighting {
                    NavigationView { SightingMapView(sighting: s) }
                } else {
                    Text("No observations for sighting").padding()
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
