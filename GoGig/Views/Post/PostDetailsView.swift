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
        ZStack {
            Group {
                if let post = postsViewModel.selectedPost {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            PostCardView(post: post)
                            PostMetadataView(post: post)
                            TagsView(exchangeCoins: post.exchangeCoins, categories: post.categories)
                            CreatorView(creatorUser: creatorUser)
                            ActionButtonsView2(isCurrentUserCreator: isCurrentUserCreator, isDeleting: isDeleting, showRequestForm: $showRequestForm, showDeletionConfirmation: $showDeletionConfirmation)
                        }
                        .padding()
                    }
                    .applyBackground()
                    .navigationBarItems(trailing: editButton)
                    .sheet(isPresented: $showUserDetails) {
                        if let userId = postsViewModel.selectedPost?.userId {
                            UserDetailsView(userId: userId)
                                .environmentObject(authViewModel)
                                .presentationCornerRadius(50)
                        }
                    }
                    .sheet(isPresented: $showRequestForm) {
                        RequestFormView(post: post, creatorUser: creatorUser!, requestMessage: $requestMessage, contactInfo: $contactInfo, onSubmit: sendRequest)
                            .presentationCornerRadius(50)
                            .presentationDetents([.medium])
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
            }
            .applyBackground()
            .navigationTitle("Post Details")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadData)

            if requestViewModel.showToast {
                ToastView(message: requestViewModel.toastMessage, isSuccess: requestViewModel.isToastSuccess)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            requestViewModel.showToast = false
                        }
                    }
                    .animation(.easeInOut, value: requestViewModel.showToast)
            }
            
            if postsViewModel.showToast {
                ToastView(message: postsViewModel.toastMessage, isSuccess: postsViewModel.isToastSuccess)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            postsViewModel.showToast = false
                        }
                    }
                    .animation(.easeInOut, value: postsViewModel.showToast)
            }
        }
    }

    
    private func deletePost(postId: String) {
        isDeleting = true
        Task {
            let success = await postsViewModel.deleteSelectedPost(postId: postId)
            isDeleting = false

            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    dismiss()
                }
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

private struct PostCardView: View {
    let post: Post
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Label(post.type, systemImage: "tag")
                Spacer()
                Label(post.isActive ? "Active" : "Inactive", systemImage: post.isActive ? "checkmark.circle" : "xmark.circle")
                    .foregroundColor(post.isActive ? .green : .red)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Text(post.title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(post.description)
                .font(.body)
            
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

private struct TagsView: View {
    let exchangeCoins: [String]
    let categories: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TagSection(icon: "dollarsign.circle", items: exchangeCoins, color: .blue)
            TagSection(icon: "tag", items: categories, color: .green)
        }
    }
}

private struct TagSection: View {
    let icon: String
    let items: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("", systemImage: icon)
                .font(.headline)
                .foregroundColor(color)
            
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

private struct PostMetadataView: View {
    let post: Post
    
    var body: some View {
        HStack {
            Label(post.postLocation, systemImage: "mappin.and.ellipse")
            Spacer()
            Label(post.createdOn.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
}

private struct CreatorView: View {
    let creatorUser: User?
    
    var body: some View {
        NavigationLink(destination: UserDetailsView(userId: creatorUser?.id ?? "")) {
            CreatorCardView(user: creatorUser, title: "View Profile")
        }
    }
}

private struct ActionButtonsView2: View {
    let isCurrentUserCreator: Bool
    let isDeleting: Bool
    @Binding var showRequestForm: Bool
    @Binding var showDeletionConfirmation: Bool
    
    var body: some View {
        if isCurrentUserCreator {
            ButtonDelete(title: "Delete Post") {
                showDeletionConfirmation = true
            }
            .disabled(isDeleting)
            
        } else {
            ButtonPrimary(title: "Send Request") {
                showRequestForm = true
            }
        }
    }
}

#Preview {
    PostDetailsView(postId:"sample-post-id")
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(RequestViewModel())
}
