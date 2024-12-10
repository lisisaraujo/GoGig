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
                            ? [Color.black.opacity(0.4), Color.deepNavy.opacity(0.9)]
                            : [Color.black.opacity(0.4), Color.deepNavy.opacity(0.9)]),
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
