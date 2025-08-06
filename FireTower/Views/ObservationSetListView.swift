//
//  ObservationSetListView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/5/25.
//

import Foundation
import SwiftUI

struct ObservationSetListView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("OBSERVATIONS")
                Spacer()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Observations")
        }
    }
}

#Preview {
    ObservationSetListView()
}
