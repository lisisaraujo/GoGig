//
//  CustomSecureFieldView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct CustomSecureFieldView: View {
    var placeholder: String
    @Binding var text: String
    var isRequired: Bool = false
    var errorMessage: String = "This field is required"
    @Binding var showError: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            SecureField(placeholder, text: $text)
                .padding(20)
                .background(Color.textSecondary.opacity(0.1))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.accent.opacity(0.3), lineWidth: 2)
                )
            
            if isRequired && text.isEmpty && showError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CustomSecureFieldView(placeholder: "123", text: .constant("123"), showError: .constant(true))
}
