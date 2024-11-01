//
//  PostItemView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct PostItemView: View {
    
    var post: Post?
    
    var body: some View {
      
        VStack(alignment: .leading) {
            if let post = post {
            
                Text(post.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                
           
                Text(post.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .padding(.bottom, 5)
                
  
                HStack {
                    Text("Type: \(post.type)")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Posted on \(formattedDate(post.createdOn))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } else {
                Text("Post not available")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
   
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    PostItemView(post: Post(id: "1", userId: "user123", type: "Offer", title: "Looking for a roommate", description: "I have a room available in my apartment. Looking for someone responsible and clean.", isActive: true, exchangeCoins: [], categories: [], createdOn: Date()))
}
