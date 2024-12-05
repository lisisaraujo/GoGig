//
//  BackgroundModifier.swift
//  Care4U
//
//  Created by Lisis Ruschel on 25.11.24.
//

import SwiftUI

struct BackgroundModifier: ViewModifier {
        @Environment(\.colorScheme) var colorScheme
        
        func body(content: Content) -> some View {
            content
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: colorScheme == .dark
                            ? [Color.deepNavy, Color.background]
                            : [Color("D0D9E0"), Color("F2F2F7")]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                    .ignoresSafeArea()
                )
        }
    }

extension View {
    func applyBackground() -> some View {
        self.modifier(BackgroundModifier())
    }
}
