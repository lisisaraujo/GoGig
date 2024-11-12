//
//  MemberSinceView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 12.11.24.
//

import SwiftUI

struct MemberSinceView: View {
    let date: Date
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
            Text("Member since: \(date.formatted(date: .abbreviated, time: .omitted))")
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    MemberSinceView(date: Date.now)
}
