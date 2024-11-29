//
//  LoadingSpinner.swift
//  Care4U
//
//  Created by Lisis Ruschel on 30.10.24.
//

import SwiftUI

struct LoadingSpinnerView: View {
    @Binding var loadingState: LoadingStateEnum
    
    @State private var animate = false

    var body: some View {
        if case .loading = loadingState {
            ZStack {
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .background(BlurView(style: .systemThinMaterialDark))
                
                VStack(spacing: 20) {
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(animate ? 1.1 : 1.0)
                        .onAppear {
                            withAnimation(
                                Animation.easeInOut(duration: 0.8)
                                    .repeatForever(autoreverses: true)
                            ) {
                                animate = true
                            }
                        }
                    
                    Text("Loading...")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 15)
            }
        }
    }
}


struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

