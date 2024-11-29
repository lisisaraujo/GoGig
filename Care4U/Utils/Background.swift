//
//  Background.swift
//  Care4U
//
//  Created by Lisis Ruschel on 14.11.24.
//

import SwiftUI

struct BackgroundView: View {
    var topColor: Color
    var bottomColor: Color
    var accentColor1: Color
    var accentColor2: Color
    
    init(topColor: Color = Color("divider"),
         bottomColor: Color = Color("background"),
         accentColor1: Color = Color("accent"),
         accentColor2: Color = Color("blue600")) {
        self.topColor = topColor
        self.bottomColor = bottomColor
        self.accentColor1 = accentColor1
        self.accentColor2 = accentColor2
    }
    
    var body: some View {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [
                        Color("divider"),
                        Color("background")
                    ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                Circle()
                    .fill(accentColor1.opacity(0.2))
                    .blur(radius: 60)
                    .offset(x: -geometry.size.width * 0.3, y: -geometry.size.height * 0.2)
                
                Circle()
                    .fill(accentColor2.opacity(0.2))
                    .blur(radius: 80)
                    .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.2)
            }
                }
                .ignoresSafeArea()
            }
        }

struct GlassyBackgroundModifier: ViewModifier {
    var backgroundColor: Color
    var opacity: Double
    var blurRadius: CGFloat
    
    init(backgroundColor: Color = Color("surfaceBackground"),
         opacity: Double = 0.2,
         blurRadius: CGFloat = 10) {
        self.backgroundColor = backgroundColor
        self.opacity = opacity
        self.blurRadius = blurRadius
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                backgroundColor
                    .opacity(opacity)
                    .blur(radius: blurRadius)
            )
            .background(
                Color("background")
                    .opacity(0.8)
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

extension View {
    func glassyBackground(backgroundColor: Color = Color("surfaceBackground"),
                          opacity: Double = 0.2,
                          blurRadius: CGFloat = 10) -> some View {
        self.modifier(GlassyBackgroundModifier(backgroundColor: backgroundColor,
                                               opacity: opacity,
                                               blurRadius: blurRadius))
    }
}
