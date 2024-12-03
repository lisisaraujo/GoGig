

//
//  PostItemView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct PostItemView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let post: Post
    @State private var isBookmarked = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(post.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                if authViewModel.isUserLoggedIn {
                    Button(action: {
                        toggleBookmark()
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(isBookmarked ? Color.accent : Color.accent)
                    }
                    .buttonStyle(PlainButtonStyle()) 
                }
            }
            
            HStack{
                Text(post.postLocation)
                    .font(.footnote)
                    .foregroundColor(Color.textSecondary)
                
                Text("• \(post.createdOn, formatter: dateFormatter)")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }.padding(.bottom, 5)
            
            Text(post.description)
                .font(.subheadline)
                .foregroundColor(Color.textSecondary)
                .lineLimit(2)
                .padding(.bottom, 10)
            
            
            HStack {
          
                
                Spacer()
                
                Text(post.exchangeCoins.joined(separator: "• "))
                    .font(.footnote)
                    .foregroundColor(Color.accent)
            }
        }
        .padding()
        .background(.buttonPrimary.opacity(0.2))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .onAppear {
            isBookmarked = postsViewModel.isPostBookmarked(post.id!)
        }
    }
    
    private func toggleBookmark() {
        if isBookmarked {
            postsViewModel.removeBookmark(postId: post.id!)
        } else {
            postsViewModel.addBookmark(postId: post.id!)
        }
        isBookmarked.toggle()
    }
    
}

#Preview {
    PostItemView(post: Post(id: "1", userId: "user123", type: "Offer", title: "Looking for a roommate", description: "I have a room available in my apartment. Looking for someone responsible and clean.", isActive: true, exchangeCoins: [], categories: [], createdOn: Date(), latitude: 22.000, longitude: 23.000, postLocation: "Berlin"))
        .background(Color("backgroundDark"))
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
