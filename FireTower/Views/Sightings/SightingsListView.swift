//
//  ObservationSetListView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI

struct SightingsListView: View {
    @ObservedObject var store: SightingStore
    @ObservedObject var locationManager: LocationManager
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = store.sightings[index]
            store.delete(itemToDelete)
        }
    }
    
    private func createNewSighting() {
        let sightingToCreate = Sighting(
            name: DateFormatter.localizedString(
                from: Date(),
                dateStyle: .medium,
                timeStyle: .none
            )
        )
        store.add(sightingToCreate)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if store.sightings.isEmpty {
                    ZStack {
                        NoSightingsView(store: store)
                    }
                } else {
                    List {
                        ForEach(store.sightings) { sighting in
                            NavigationLink(
                                destination: CompassMapContainerView(
                                    id: sighting.id,
                                    store: store,
                                    locationManager: locationManager
                                )
                            ) {
                                VStack(alignment: .leading) {
                                    Text(sighting.name)
                                        .font(.headline)
                                    Text("\(sighting.observations.count) of \(Sighting.maxObservationCount) observations")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .background(Color(.systemBackground))
                }
            }
            .navigationTitle("Sightings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: createNewSighting) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    SightingsListView(
        store: .preview,
        locationManager: .preview
    )
}
