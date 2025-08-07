//
//  LaunchScreenView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/6/25.
//

import Foundation
import SwiftUI

struct LaunchScreenView: View {
    @State private var smokeOffset: CGFloat = 100
    @State private var fadeOut = false
    
    var body: some View {
        ZStack {
            // Background sky
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(Theme.Colors.Primary),
                    Color(.systemOrange)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()

                FireTowerSilhouette()
                    .offset(y: 60)
            }
        }
        .opacity(fadeOut ? 0 : 1)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation(.easeOut(duration: 1.75)) {
                    fadeOut = true
                }
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
