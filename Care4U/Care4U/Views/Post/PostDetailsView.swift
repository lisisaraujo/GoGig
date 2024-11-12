//
//  PostDetailsView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct PostDetailsView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedTab: HomeTabEnum
    
    let postId: String
    @State private var showUserDetails = false
    @State private var isLoading = true
    @State private var creatorUser: User? 
    
    private var isCurrentUserCreator: Bool {
        guard let post = postsViewModel.selectedPost,
              let currentUserId = authViewModel.currentUser?.id else {
            return false
        }
        return post.userId == currentUserId
    }
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let post = postsViewModel.selectedPost {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        PostHeaderView(post: post)
                        PostContentView(post: post)
                        PostMetadataView(post: post)
                        CreatorCardView(post: post, creatorUser: creatorUser, showUserDetails: $showUserDetails)
                        
                        if isCurrentUserCreator {
                            Button("Delete Post") {
                                postsViewModel.deleteSelectedPost(postId: postId)
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarItems(trailing: editButton)
                .sheet(isPresented: $showUserDetails) {
                    if let userId = postsViewModel.selectedPost?.userId {
                        UserDetailsView(userId: userId, selectedTab: $selectedTab)
                            .environmentObject(authViewModel)
                    }
                }
            } else {
                Text("Post not found")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadData)
    }

    private func loadData() {
        Task {
            await postsViewModel.getSelectedPost(with: postId)
            if authViewModel.currentUser == nil {
                await authViewModel.checkAuth()
            }
            // fetch creator information based on post's userId
            if let userId = postsViewModel.selectedPost?.userId {
                await authViewModel.fetchSelectedUser(with: userId)
                creatorUser = authViewModel.selectedUser
            }
            isLoading = false
        }
    }

    @ViewBuilder
    private var editButton: some View {
        if isCurrentUserCreator { // show edit button only if current user is creator
            NavigationLink(destination: EditPostView(selectedTab: $selectedTab, post: postsViewModel.selectedPost!)) {
                Text("Edit")
            }
        }
    }
}
struct PostHeaderView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.title)
                .fontWeight(.bold)
            Label(post.type, systemImage: "tag")
            Label(post.isActive ? "Active" : "Inactive", systemImage: post.isActive ? "checkmark.circle" : "xmark.circle")
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
}

struct PostContentView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(post.description)
                .font(.body)

            TagsSectionView(title: "Exchange Coins", items: post.exchangeCoins, color: .blue)
            TagsSectionView(title: "Categories", items: post.categories, color: .green)
        }
    }
}

struct TagsSectionView: View {
    let title: String
    let items: [String]
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(color.opacity(0.1))
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
}

struct PostMetadataView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(post.postLocation, systemImage: "mappin.and.ellipse")
            Label(post.createdOn.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
}

struct CreatorCardView: View {
    let post: Post
    let creatorUser: User?
    @Binding var showUserDetails: Bool
    
    var body: some View {
        Button(action: {
            showUserDetails = true
        }) {
            HStack {
                AsyncImage(url: URL(string: creatorUser?.profilePicURL ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName:"person.circle")
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                VStack(alignment:.leading) {
                    Text(creatorUser?.fullName ?? "No name")
                        .font(.headline)
                    Text("View Profile")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                Spacer()
                Image(systemName:"chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PostDetailsView(selectedTab:.constant(.search), postId:"sample-post-id")
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
