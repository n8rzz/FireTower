//
//  NoSightingsView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/8/25.
//

import Foundation
import SwiftUI

struct NoSightingsView: View {
    @ObservedObject var store: SightingStore
    
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
        VStack {
            Text("No sightings yet")
            Button(action: createNewSighting) {
                Label("Add your first sighting", systemImage: "plus")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(.white)
            .tint(Theme.Colors.Primary)
            .controlSize(.large)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }
    
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [
//                    Color(Theme.Colors.Primary),
//                    Color(.systemOrange)
//                ]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 16) {
//                Spacer()
//                
//                Text("No sightings yet")
//                    .font(.title)
//                    .foregroundColor(Theme.Colors.TextPrimary)
//                
//                Button(action: createNewSighting) {
//                    Label("Add your first sighting", systemImage: "plus")
//                        .font(.headline)
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.borderedProminent)
//                .foregroundColor(.white)
//                .tint(Theme.Colors.Primary)
//                .controlSize(.large)
//                .padding(.horizontal, 20)
//                .padding(.vertical, 12)
//                
//                Spacer()
//                
//                FireTowerSilhouette()
//                    .offset(y: 60)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//    }
}

#Preview {
    NoSightingsView(
        store: .preview
    )
}
