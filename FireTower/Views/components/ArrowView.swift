//
//  ArrowView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/6/25.
//

import Foundation
import SwiftUI

struct ArrowView: View {
    private var lineColor: Color
    private var lineWidth: CGFloat
    private var shaftHeight: CGFloat
    
    init(
        shaftHeight: CGFloat = 300,
        lineWidth: CGFloat = 8,
        lineColor: Color = .black
    ) {
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.shaftHeight = shaftHeight
    }
    
    var body: some View {
        ZStack {
            // Shaft
            Rectangle()
                .fill(lineColor)
                .frame(width: lineWidth, height: shaftHeight)
                .offset(y: 0)
            
            ArrowHead()
                .fill(lineColor)
                .frame(width: lineWidth * 4, height: lineWidth * 4)
                .offset(y: -1 * (shaftHeight/2))
        }
        .offset(y: 5.0)
    }
}

#Preview {
    ArrowView()
}
