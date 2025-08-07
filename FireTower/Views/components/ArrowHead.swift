//
//  ArrowHead.swift
//  FireTower
//
//  Created by Nate Geslin on 8/6/25.
//

import Foundation
import SwiftUI

struct ArrowHead: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))       // top
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))    // bottom right
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))    // bottom left
        path.closeSubpath()

        return path
    }
}
