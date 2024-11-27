

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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(post.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("primaryText"))
                
                Spacer()
                
                if authViewModel.isUserLoggedIn {
                    Button(action: {
                        toggleBookmark()
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(isBookmarked ? Color.blue : Color.gray)
                    }
                    .buttonStyle(PlainButtonStyle()) 
                }
            }
            
            Text(post.description)
                .font(.subheadline)
                .foregroundColor(Color("secondaryText"))
                .lineLimit(2)
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(Color.gray)
                Text(post.postLocation)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            
            HStack {
                Text("Posted on \(post.createdOn, formatter: dateFormatter)")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                
                Spacer()
                
                Text(post.exchangeCoins.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundColor(Color.blue)
            }
        }
        .padding()
        .background(Color("surfaceBackground").opacity(0.7))
        .cornerRadius(10)
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
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

#Preview {
    PostItemView(post: Post(id: "1", userId: "user123", type: "Offer", title: "Looking for a roommate", description: "I have a room available in my apartment. Looking for someone responsible and clean.", isActive: true, exchangeCoins: [], categories: [], createdOn: Date(), latitude: 22.000, longitude: 23.000, postLocation: "Berlin"))
        .background(Color("backgroundDark"))
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
