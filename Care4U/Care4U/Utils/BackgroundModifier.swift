//
//  BackgroundModifier.swift
//  Care4U
//
//  Created by Lisis Ruschel on 25.11.24.
//

import SwiftUI

struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Image("codioful-formerly-gradienta-OzfD79w8ptA-unsplash")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.5)
            )
    }
}

extension View {
    func applyBackground() -> some View {
        self.modifier(BackgroundModifier())
    }
}
