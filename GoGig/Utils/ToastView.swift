//
//  ToastView.swift
//  GoGig 
//
//  Created by Lisis Ruschel on 01.12.24.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let isSuccess: Bool
    
    var body: some View {
        Text(message)
            .padding()
            .background(isSuccess ? Color.buttonPrimary.opacity(0.5) : Color.red.opacity(0.5))
            .foregroundColor(Color.textPrimary)
            .cornerRadius(15)
            .transition(.move(edge: .top).combined(with: .opacity))
    }
}

#Preview {
    ToastView(message: "Toast message", isSuccess: true)
}
