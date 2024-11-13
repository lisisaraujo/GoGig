//
//  AppBackgroundModifier.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import SwiftUI

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color("BackgroundDark")
                .ignoresSafeArea()
            content
        }
    }
}


extension View {
    func withAppBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }
}
