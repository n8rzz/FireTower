//
//  CompassDial.swift
//  FireTower
//
//  Created by Nate Geslin on 8/10/25.
//

import Foundation
import SwiftUI

struct CompassDial: View {
    let size: CGFloat
    let arrowHeight: CGFloat
    let headingDegrees: Double
    
    var body: some View {
        ZStack {
            // MARK: - Rotating Compass Card
            ZStack {
                // Outer Ring
                Circle()
                    .strokeBorder(lineWidth: 2)
                
                // 10 Deg minor ticks
                ForEach(Array(stride(from: 0, through: 350, by: 10)), id: \.self) { deg in
                    Tick(height: 6, width: 1)
                        .offset(y: -size * 0.5 + 16)
                        .rotationEffect(.degrees(Double(deg)))
                }
                
                // 30 Deg major ticks
                ForEach(Array(stride(from: 0, through: 330, by: 30)), id: \.self) { deg in
                    Tick(height: 14, width: 2)
                        .offset(y: -size * 0.5 + 16)
                        .rotationEffect(.degrees(Double(deg)))
                }
                
                ForEach([0, 90, 180, 270], id: \.self) { deg in
                    Tick(height: 20, width: 3)
                        .offset(y: -size * 0.5 + 16)
                        .rotationEffect(.degrees(Double(deg)))
                }
                
                let r = size * 0.5 - 36
                
                AroundCircle(angle: 0,   radius: r) { CardinalLabel("N") }
                AroundCircle(angle: 90,  radius: r) { CardinalLabel("E") }
                AroundCircle(angle: 180, radius: r) { CardinalLabel("S") }
                AroundCircle(angle: 270, radius: r) { CardinalLabel("W") }
            }
            .frame(width: size, height: size)
            .rotationEffect(.degrees(-headingDegrees))
            
            // MARK: - Fixed arrow (points up)
            VStack(spacing: 0) {
                Triangle()
                    .frame(width: 22, height: 22)
//                    .offset(y: -2)
                Capsule(style: .continuous)
                    .frame(width: 4, height: arrowHeight)
            }
            .accessibilityHidden(true)
            
            // Center Dot
            Circle()
                .fill()
                .frame(width: 15, height: 15)
        }
        .frame(width: size, height: size)
        .drawingGroup()
        .accessibilityElement(children: .ignore)
        .accessibilityValue("\(Int(headingDegrees)) degrees")
    }
}

// MARK: - Preview with a test knob
#Preview {
    StatefulPreview()
}

private struct StatefulPreview: View {
    @State private var heading: Double = 0
    
    var body: some View {
        VStack(spacing: 24) {
            CompassDial(size: 300, arrowHeight: 130, headingDegrees: heading)
                .animation(.easeInOut(duration: 0.2), value: heading)
                .overlay(
                    HeadingBadge(degrees: heading, sourceText: "Mag").padding(.top, 8),
                    alignment: .top
                )

            // A simple scrubber to simulate heading changes
            VStack {
                Text("Heading: \(Int(heading))°")
                Slider(value: $heading, in: 0...360, step: 1)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}
