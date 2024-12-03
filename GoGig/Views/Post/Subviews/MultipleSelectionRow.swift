//
//  MultipleSelectionView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 12.11.24.
//

import SwiftUI

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
            .padding()
            .background(isSelected ? Color.accent.opacity(0.2) : Color.clear)
            .cornerRadius(15)
        }
        .foregroundColor(.textPrimary)
    }
}

#Preview {
    MultipleSelectionRow(title: "Hello", isSelected: false, action: { print("Form submitted") })
}
