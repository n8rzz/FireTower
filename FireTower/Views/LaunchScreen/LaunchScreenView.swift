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
    @State private var displayDuration: CGFloat = 7.5
    @State private var shouldFadeOut = false
    
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
        .opacity(shouldFadeOut ? 0 : 1)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) {
                withAnimation(.easeOut(duration: 1.75)) {
                    shouldFadeOut = true
                }
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
