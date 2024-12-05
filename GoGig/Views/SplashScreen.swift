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
                .background()
                .ignoresSafeArea()

            VStack {
                Image("GoGig")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
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
