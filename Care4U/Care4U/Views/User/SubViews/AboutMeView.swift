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
        VStack(alignment: .leading, spacing: 10) {
            Text("About Me")
                .font(.headline)
            Text(description ?? "No description provided")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    AboutMeView(description: "")
}
