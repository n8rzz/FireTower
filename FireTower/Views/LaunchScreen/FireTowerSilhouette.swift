//
//  FireTowerSilhouette.swift
//  FireTower
//
//  Created by Nate Geslin on 8/6/25.
//

import Foundation
import SwiftUI

struct FireTowerSilhouette: View {
    var body: some View {
//        Image("firetower_icon")
        Image("fire_tower_launch_screen_illustration")
            .resizable()
            .scaledToFit()
            .foregroundColor(.black)
    }
}

#Preview {
    FireTowerSilhouette()
}
