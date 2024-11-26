//
//  CreatorCardView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 15.11.24.
//

import SwiftUI

struct CreatorCardView: View {
    let user: User?
    let title: String
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user?.profilePicURL ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.circle")
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(user?.fullName ?? "No name")
                    .font(.headline)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .cornerRadius(12)
    }
}

//#Preview {
//    CreatorCardView()
//}
