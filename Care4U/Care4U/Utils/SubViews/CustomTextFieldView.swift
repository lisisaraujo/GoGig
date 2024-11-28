//
//  CustomTextFieldView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct CustomTextFieldView: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(20)
            .background(Color.textSecondary.opacity(0.1))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.accent.opacity(0.3), lineWidth: 2)
            )
        
    }
}


#Preview {
    CustomTextFieldView(placeholder: "123", text: .constant("123"))
}
