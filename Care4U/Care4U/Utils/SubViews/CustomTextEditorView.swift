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

    var body: some View {
        VStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.textSecondary)
                    .padding(.top, 8)
            }
            TextEditor(text: $text)
                .padding(10)
                .background(Color.textSecondary.opacity(0.1))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.accent.opacity(0.3), lineWidth: 2)
                )
                .frame(height: 150) 
        }
    }
}

#Preview {
    CustomTextEditorView(placeholder: "123", text: .constant("123"))
}
