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
    let date: Date
    
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
            .overlay(Circle().stroke(Color.buttonPrimary.opacity(0.5), lineWidth: 2))
            .shadow(radius: 5)
            
        
                Text(user.fullName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.vertical, 5)
                
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.accent)
                    Text(user.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            HStack {
                Image(systemName: "calendar")
                Text("Member since: \(date.formatted(date: .abbreviated, time: .omitted))")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
        }
        
    }
}


#Preview {
    ProfileHeaderView(user: sampleUser, imageSize: 150, date: .now)
}
