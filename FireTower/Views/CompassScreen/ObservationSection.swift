//
//  ObservationsSection.swift
//  FireTower
//
//  Created by Nate Geslin on 8/10/25.
//

import Foundation
import SwiftUI

struct ObservationsSection: View {
    let observations: [Observation]
    let maxCount: Int
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Observations (\(observations.count)/\(maxCount))")
                .font(.headline)
                .padding(.horizontal, 16)
            
            if observations.isEmpty {
                Text("No observations yet")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
            } else {
                // Replace your ScrollView/LazyVStack with this:
                List {
                    ForEach(observations) { obs in
                        // Card content
                        VStack(alignment: .leading, spacing: 4) {
                            Text(obs.name).font(.headline)
                            Text("Heading: \(Int(obs.heading))°")
                            Text("Location: \(obs.latitude), \(obs.longitude)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        // INTERNAL padding (inside the card)
                        .padding(12)
                        // Make the row fill the entire list width
                        .frame(maxWidth: .infinity, alignment: .leading)
                        // Card background
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                        .contentShape(Rectangle()) // good for taps/menus
                        // OUTER spacing (gutter around the card)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: onDelete)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden) // optional: remove default grouped bg
                .frame(maxHeight: 300)
            }
        }
    }
}

#Preview {
    ObservationsSection(
        observations: Observation.previewList,
        maxCount: 5,
        onDelete: { _ in }
    )
    .padding()
}
