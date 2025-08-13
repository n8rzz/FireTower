//
//  HeadingBadge.swift
//  FireTower
//
//  Created by Nate Geslin on 8/9/25.

import Foundation
import SwiftUI

struct HeadingBadge: View {
    let degrees: Double?
    let sourceText: String?

    // Keep all badges the same size as a "worst case" (the middle one)
    // Tweak these if your largest strings change.
    private let reserveSampleDegrees = "359°"
    private let reserveSampleSource  = "TRUE"
    private let cornerRadius: CGFloat = 14

    private var formattedDegrees: String {
        guard let d = degrees else { return "—°" }
        let r = d.truncatingRemainder(dividingBy: 360)
        let n = r < 0 ? r + 360 : r
        return "\(Int(round(n)))°"
    }

    var body: some View {
        // Background shape once, so we don't repeat it
        let box = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            // Calibrator: invisible but reserves space so all badges match
            VStack(spacing: 4) {
                Text(reserveSampleDegrees)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                Text(reserveSampleSource)
                    .font(.system(size: 8)).bold()
            }
            .opacity(0)

            // Actual content
            VStack(spacing: 4) {
                Text(formattedDegrees)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .monospacedDigit()

                if let s = sourceText {
                    Text(s.uppercased())
                        .font(.caption).bold()
                }
            }
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.thinMaterial, in: box)
        .overlay(box.stroke(Color.primary.opacity(0.15), lineWidth: 1))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Heading")
        .accessibilityValue("\(formattedDegrees) \(sourceText?.uppercased() ?? "")")
    }
}

#Preview {
    VStack(spacing: 16) {
        HeadingBadge(degrees: 12, sourceText: "Mag")
        HeadingBadge(degrees: 358.6, sourceText: "True")
        HeadingBadge(degrees: nil, sourceText: nil)
    }
    .padding()
}
