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
    }
}


#Preview {
    MemberSinceView(date: Date.now)
}
