//
//  CardinalLabel.swift
//  FireTower
//
//  Created by Nate Geslin on 8/10/25.
//

import Foundation
import SwiftUI

struct CardinalLabel: View {
    let text: String
    init(_ text: String) { self.text = text }
 
    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .kerning(1)
    }
}
