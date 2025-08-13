//
//  Compass.swift
//  FireTower
//
//  Created by Nate Geslin on 8/10/25.
//

import Foundation
import SwiftUI

struct CompassHeader: View {
    let headingDegrees: Double?
    let headingDegreesDisplay: Double?
    let headingSourceText: String?

    var accent: Color = .primary

    var body: some View {
        GeometryReader { geo in
            let dialSize = min(geo.size.width, geo.size.height)
            let arrowH = dialSize * 0.6
            let h = headingDegrees ?? 0

            VStack(spacing: 12) {
                HeadingBadge(
                    degrees: headingDegreesDisplay,
                    sourceText: headingSourceText
                )

                CompassDial(
                    size: dialSize,
                    arrowHeight: arrowH,
                    headingDegrees: h
                )
                .tint(accent)
                .foregroundStyle(accent)
                .animation(
                    .interactiveSpring(
                        response: 0.25,
                        dampingFraction: 0.9,
                        blendDuration: 0.12
                    ),
                    value: h
                )

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 360)
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    struct Demo: View {
        @State private var heading = 0.0
        
        var body: some View {
            VStack(spacing: 24) {
                CompassHeader(
                    headingDegrees: heading,
                    headingDegreesDisplay: heading,
                    headingSourceText: "Mag",
                    accent: .primary
                )
                
                Spacer()
                
                VStack {
                    Text("Heading: \(Int(heading))°")
                    Slider(value: $heading, in: 0...360, step: 1)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
    }
    
    return Demo()
}



