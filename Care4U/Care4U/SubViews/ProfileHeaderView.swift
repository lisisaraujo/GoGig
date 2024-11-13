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
        VStack {
            AsyncImage(url: URL(string: user.profilePicURL ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
            .frame(width: imageSize, height: imageSize)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
            .shadow(radius: 5)
            
            Text(user.fullName)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(user.location)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}


//#Preview {
//    ProfileHeaderView(user: sampleUser, imageSize: <#CGFloat#>)
//}
