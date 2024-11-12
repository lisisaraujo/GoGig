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
    
    @Binding var selectedTab: HomeTabEnum
    
    let post: Post
    
    @State private var isBookmarked = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            
            NavigationLink(destination: PostDetailsView(selectedTab: $selectedTab, postId: post.id!)
                .environmentObject(postsViewModel)
                .environmentObject(authViewModel)) {
                    
                    VStack(alignment: .leading) {
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
                            Text(post.type)
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Text("Posted on \(formattedDate(post.createdOn))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // show bookmark button if user is logged in
            if authViewModel.isUserLoggedIn {
                
                Button(action: {
                    if isBookmarked {
                        postsViewModel.removeBookmark(postId: post.id!)
                    } else {
                        postsViewModel.addBookmark(postId: post.id!)
                    }
                    isBookmarked.toggle()
                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .padding(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onAppear(perform: updateBookmarkStatus)
        .onChange(of: postsViewModel.bookmarkedPostsIds) { _,_ in
            updateBookmarkStatus()
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func updateBookmarkStatus() {
        isBookmarked = postsViewModel.isPostBookmarked(post.id ?? "")
    }
}

#Preview {
    PostItemView(selectedTab: .constant(.search), post: Post(id: "1", userId: "user123", type: "Offer", title: "Looking for a roommate", description: "I have a room available in my apartment. Looking for someone responsible and clean.", isActive: true, exchangeCoins: [], categories: [], createdOn: Date(), latitude: 22.000, longitude: 23.000, postLocation: "Berlin"))
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
