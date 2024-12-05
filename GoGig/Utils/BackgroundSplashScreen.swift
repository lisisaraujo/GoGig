//
//  BackgroundSplashScreen.swift
//  GoGig 
//
//  Created by Lisis Ruschel on 05.12.24.
//

import SwiftUI

struct BackgroundSplashScreen: ViewModifier {
        @Environment(\.colorScheme) var colorScheme
        
        func body(content: Content) -> some View {
            content
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: colorScheme == .dark
                            ? [Color.black, Color.deepNavy]
                            : [Color("D0D9E0"), Color("F2F2F7")]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                    .ignoresSafeArea()
                )
        }
    }

extension View {
    func background() -> some View {
        self.modifier(BackgroundSplashScreen())
    }
}
