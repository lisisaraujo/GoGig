//
//  TerciaryButton.swift
//  Care4U
//
//  Created by Lisis Ruschel on 14.11.24.
//

import SwiftUI

struct ButtonPrimary: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.textPrimary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.buttonPrimary)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
}

struct ButtonSecondary: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.buttonPrimary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.buttonSecondary)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
}