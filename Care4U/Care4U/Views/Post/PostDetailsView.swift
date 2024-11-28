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
    @EnvironmentObject var requestViewModel: RequestViewModel
    @Environment(\.dismiss) private var dismiss
    
    let postId: String
    @State private var showUserDetails = false
    @State private var isLoading = true
    @State private var creatorUser: User?
    @State private var showRequestForm = false
    @State private var showRequestConfirmation = false
    @State private var showDeletionConfirmation = false
    @State private var isDeleting = false
    @State private var requestMessage = ""
    @State private var contactInfo = ""

    
    private var isCurrentUserCreator: Bool {
        guard let post = postsViewModel.selectedPost,
              let currentUserId = authViewModel.currentUser?.id else {
            return false
        }
        return post.userId == currentUserId
    }
    
    var body: some View {
        Group {
       if let post = postsViewModel.selectedPost {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        PostHeaderView(post: post)
                        PostContentView(post: post)
                        PostMetadataView(post: post)
                        NavigationLink(destination: UserDetailsView(userId: creatorUser?.id ?? "")) {
                            CreatorCardView(user: creatorUser, title: "View Profile")
                        }
                        
                        if isCurrentUserCreator, authViewModel.isUserLoggedIn {
                            Button("Delete Post") {
                                showDeletionConfirmation = true
                            }
                            .buttonStyle(.borderedProminent)
                                                       .tint(.red)
                                                       .disabled(isDeleting)
                            
                        } else {
                            
                            Button("Send Request") {
                            showRequestForm = true
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                }.applyBackground()
                .navigationBarItems(trailing: editButton)
                .sheet(isPresented: $showUserDetails) {
                    if let userId = postsViewModel.selectedPost?.userId {
                        UserDetailsView(userId: userId)
                            .environmentObject(authViewModel)
                    }
                }
                .sheet(isPresented: $showRequestForm) {

                        RequestFormView(post: post, creatorUser: creatorUser!, requestMessage: $requestMessage, contactInfo: $contactInfo, onSubmit: sendRequest)

                }
                .alert("Request Sent", isPresented: $showRequestConfirmation) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Your request has been sent.")
                }
                .alert("Confirm Deletion", isPresented: $showDeletionConfirmation) {
                                    Button("Delete", role: .destructive) {
                                        deletePost(postId: postId)
                                    }
                                    Button("Cancel", role: .cancel) {}
                                } message: {
                                    Text("Are you sure you want to delete this post? This action cannot be undone.")
                                }
            } else {
                Text("Post not found")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }.applyBackground()
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadData)
        
    }
    
    private func deletePost(postId: String) {
        isDeleting = true
        Task {
            let success = await postsViewModel.deleteSelectedPost(postId: postId) 
            isDeleting = false
            
            if success {
                showDeletionConfirmation = false
                dismiss()
            } else {
            }
        }
    }
    
    private func sendRequest() {
        Task {
            guard let post = postsViewModel.selectedPost else { return }
            
            requestViewModel.sendRequest(recipientUserId: post.userId, postId: post.id!, postTitle: post.title, message: requestMessage, contactInfo: contactInfo)
            
            await MainActor.run {
                showRequestForm = false
                showRequestConfirmation = true
            }
        }
    }

    private func loadData() {
        Task {
            await postsViewModel.getSelectedPost(with: postId)
            if authViewModel.currentUser == nil {
                await authViewModel.checkAuth()
            }
            if let userId = postsViewModel.selectedPost?.userId {
                await creatorUser = authViewModel.fetchUserData(with: userId)
              
            }
            isLoading = false
        }
    }

    @ViewBuilder
    private var editButton: some View {
        if isCurrentUserCreator {
            NavigationLink(destination: EditPostView(post: postsViewModel.selectedPost!)) {
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



#Preview {
    PostDetailsView(postId:"sample-post-id")
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(RequestViewModel())
}
