//
//  CustomTextEditorFieldView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 01.11.24.
//

import SwiftUI

struct CustomTextEditorView: View {
    var placeholder: String
    @Binding var text: String
    var isRequired: Bool = false
    var errorMessage: String = "This field is required"
    @Binding var showError: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.textSecondary.opacity(0.4))
                        .padding(.top, 8)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                }
                TextEditor(text: $text)
                    .padding(10)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.accent.opacity(0.3), lineWidth: 2)
                    )
                    .frame(height: 150)
            }
            
            if isRequired && text.isEmpty && showError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    CustomTextEditorView(placeholder: "123", text: .constant(""), showError: .constant(true))
}
