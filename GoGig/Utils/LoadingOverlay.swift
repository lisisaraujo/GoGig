//
//  LoadingOverlay.swift
//  GoGig 
//
//  Created by Lisis Ruschel on 04.12.24.
//

import SwiftUI

struct LoadingOverlay: View {
    let message: String

    var body: some View {
        VStack {
            Spacer()
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                Text(message)
                    .foregroundColor(Color.white)
                    .padding(.top)
            }
            .frame(width: 200, height: 200)
            .background(Color.gray.opacity(0.7))
            .cornerRadius(20)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
        .zIndex(3)
    }
}

#Preview {
    LoadingOverlay(message: "Loading")
}
