//
//  AroundCircle.swift
//  FireTower
//
//  Created by Nate Geslin on 8/10/25.
//

import Foundation
import SwiftUI

// Helper: position content around a circle, keeping text upright
struct AroundCircle<Content: View>: View {
    let angle: Double
    let radius: CGFloat
    let content: () -> Content

    var body: some View {
        content()
            .rotationEffect(.degrees(-angle))    // keep upright
            .offset(y: -radius)                  // move up to the rim
            .rotationEffect(.degrees(angle))     // then spin into place
    }
}

