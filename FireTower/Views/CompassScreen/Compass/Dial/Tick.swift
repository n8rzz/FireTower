//
//  Tick.swift
//  FireTower
//
//  Created by Nate Geslin on 8/10/25.
//

import Foundation
import SwiftUI

struct Tick: View {
    let height: CGFloat
    let width: CGFloat
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .cornerRadius(width/2)
    }
}
