//
//  ToastBanner.swift
//  FireTower
//
//  Created by Nate Geslin on 8/9/25.
//

import Foundation
import SwiftUI

struct ToastBanner: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle")
            Text(text)
                .monospacedDigit()
        }
        .font(.subheadline)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(radius: 2, y: 1)
        .accessibilityAddTraits(.isStaticText)
    }
}
