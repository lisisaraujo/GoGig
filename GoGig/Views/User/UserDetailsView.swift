//
//  UserDetailsView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct UserDetailsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    
    var userId: String
    @State private var isLoading = true
    @State private var user: User?
    @State private var text: String? = "Posts"
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .padding()
            } else if let user = user {
                VStack(spacing: 20) {
                    ProfileHeaderView(user: user, imageSize: 120, date: user.memberSince)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                    RatingView(rating: user.averageRating, reviewCount: user.reviewCount)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                    AboutMeView(description: user.description)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                    ReviewsScrollView(reviews: authViewModel.userReviews)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                    PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == userId }, text: $text)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                }
                .padding()
            } else {
                VStack {
                    Spacer()
                    Text("User not found")
                        .font(.headline)
                        .foregroundColor(.pink)
                    Spacer()
                }
                .padding()
            }
        }.applyBackground()
        .navigationTitle("User Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadUserData()
        }
    }
    
    private func loadUserData() {
        isLoading = true
        Task {
            if userId == authViewModel.currentUser?.id {
                user = authViewModel.currentUser
            } else {
                await authViewModel.fetchUserData(with: userId)
                user = authViewModel.selectedUser
            }
           await authViewModel.fetchUserReviews(for: userId)
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

#Preview {
    UserDetailsView(userId: "String")
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
