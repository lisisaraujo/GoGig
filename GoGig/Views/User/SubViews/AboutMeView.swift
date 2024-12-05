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
        Section(header: Text("About Me")) {
            Text(description ?? "No description provided")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
               
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

#Preview {
    AboutMeView(description: "Hi, I'm Lexi")
}
