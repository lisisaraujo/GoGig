//
//  ProfileHeaderView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 12.11.24.
//

import SwiftUI

struct ProfileHeaderView: View {
    let user: User
    let imageSize: CGFloat
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: user.profilePicURL ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.gray)
            }
            .frame(width: imageSize, height: imageSize)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.blue, lineWidth: 4))
            
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.title)
                    .fontWeight(.bold)
                Text(user.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}


//#Preview {
//    ProfileHeaderView(user: sampleUser, imageSize: <#CGFloat#>)
//}
