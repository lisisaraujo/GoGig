//
//  AboutMeView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 12.11.24.
//

import SwiftUI

struct AboutMeView: View {
    let description: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("About Me")
                .font(.headline)
            Text(description ?? "Tell us about yourself...")
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    AboutMeView(description: "")
}
