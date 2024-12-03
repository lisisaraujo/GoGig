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
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: user?.profilePicURL ?? "")) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 2)
            )
     
            VStack(alignment: .leading, spacing: 5) {
                Text(user?.fullName ?? "No name")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
           
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.buttonSecondary.opacity(0.2))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

//#Preview {
//    CreatorCardView()
//}
