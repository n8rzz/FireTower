import Foundation
import SwiftUI

struct SightingDetailView: View {
    let id: UUID

    @ObservedObject var store: SightingStore
    @State private var editedName: String = ""

    private var sighting: Sighting {
        store.sightings.first(where: { $0.id == id }) ?? .preview
    }

    var body: some View {
        List {
            // Editable name field
            Section(header: Text("Sighting Name")) {
                TextField("Enter name", text: $editedName, onCommit: commitNameChange)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
            }

            // Observation list
            Section(
                header: Text("Observations (\(sighting.observations.count)/\(Sighting.maxObservationCount))"),
                footer: sighting.observations.count >= Sighting.maxObservationCount
                    ? Text("Maximum of \(Sighting.maxObservationCount) observations reached.")
                        .foregroundColor(.secondary)
                    : nil
            ) {
                if sighting.observations.isEmpty {
                    Text("No observations yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(sighting.observations) { obs in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(obs.name)
                                .font(.headline)
                            Text("Heading: \(Int(obs.heading))°")
                            Text("Location: \(obs.latitude), \(obs.longitude)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deleteObservation)
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addObservation) {
                    Image(systemName: "plus")
                }
                .disabled(sighting.observations.count >= Sighting.maxObservationCount)
            }
        }
        .onAppear {
            editedName = sighting.name
        }
    }

    private func addObservation() {
        var updated = sighting
        let nextIndex = updated.observations.count + 1
        let newObservation = Observation.preview

        updated.addObservation(newObservation)
        store.update(updated)
    }

    private func deleteObservation(at offsets: IndexSet) {
        var modified = sighting
        for index in offsets {
            let toDelete = modified.observations[index]
            modified.deleteObservation(toDelete)
        }
        store.update(modified)
    }

    private func commitNameChange() {
        guard editedName != sighting.name, !editedName.isEmpty else { return }
        var updated = sighting
        updated.name = editedName
        store.update(updated)
    }
}

#Preview {
    SightingDetailView(
        id: Sighting.preview.id,
        store: .preview
    )
}
