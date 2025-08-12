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
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(observations) { obs in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(obs.name).font(.headline)
                                Text("Heading: \(Int(obs.heading))°")
                                Text("Location: \(obs.latitude), \(obs.longitude)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 16)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    if let index = observations.firstIndex(where: { $0.id == obs.id }) {
                                        onDelete(IndexSet(integer: index))
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
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
