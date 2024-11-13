

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

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(post.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white.opacity(0.9))
                    
                    Spacer()
                    
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
                                .foregroundColor(.white.opacity(0.9))
                                .padding(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Text(post.description)
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.7))
                    .lineLimit(2)
                
                HStack {
                    Text(post.type)
                        .font(.caption)
                        .foregroundColor(Color.white.opacity(0.6))
                    
                    Spacer()
                    
                    Text("Posted on \(formattedDate(post.createdOn))")
                        .font(.caption)
                        .foregroundColor(Color.white.opacity(0.6))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("Blue600").opacity(0.4))
            .cornerRadius(5)
         
        }
        .background(Color.clear)
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
        .background(Color("backgroundDark"))
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
