//
//  HeadingBadge.swift
//  FireTower
//
//  Created by Nate Geslin on 8/9/25.
//

import Foundation
import SwiftUI

struct HeadingBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.headline).monospacedDigit()
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.secondary, lineWidth: 4)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color(.systemBackground))
                    )
            )
            .accessibilityLabel("Current heading \(text)")
    }
}

#Preview {
    VStack {
        HeadingBadge(text: "123")

        Spacer()
    }
    
}
