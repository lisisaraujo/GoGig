//
//  CustomTextFieldView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI
import PhotosUI

struct CustomTextFieldView: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        
    }
}


#Preview {
    CustomTextFieldView(placeholder: "123", text: .constant("123"))
}
