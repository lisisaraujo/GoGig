//
//  SplashScreen.swift
//  GoGig 
//
//  Created by Lisis Ruschel on 29.11.24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var scale = 0.8
    @State private var opacity = 0.5

    var body: some View {
        ZStack {
            Color.clear
                .applyBackground()
                .ignoresSafeArea()

            VStack {
                Image("GoGig") // Ensure this image is added to your Assets.xcassets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.scale = 0.9
                            self.opacity = 1.0
                        }
                    }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            ContentView()
        }
    }
}
#Preview {
    SplashScreen()
}
