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
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
            TextEditor(text: $text)
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .frame(height: 150) 
        }
    }
}

#Preview {
    CustomTextEditorView(placeholder: "123", text: .constant("123"))
}
