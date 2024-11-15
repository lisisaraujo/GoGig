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
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .padding()
            } else if let user = authViewModel.selectedUser, user.id == userId {
                VStack(spacing: 20) {
                    ProfileHeaderView(user: user, imageSize: 120)
                    RatingView(rating: user.averageRating, reviewCount: user.reviewCount)
                    AboutMeView(description: user.description)
                    MemberSinceView(date: user.memberSince)
                    ReviewsScrollView(reviews: authViewModel.userReviews)
                    PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == userId })
                }
                .padding()
            } else {
                VStack {
                    Text("User not found")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text("User ID: \(userId)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Selected User ID: \(authViewModel.selectedUser?.id ?? "nil")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("User Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadUserData()
        }
    }
    
    private func loadUserData() {
        isLoading = true
        Task {
            await authViewModel.fetchSelectedUser(with: userId)
            await MainActor.run {
                isLoading = false
            }
        }
    }
}


#Preview {
    UserDetailsView(userId: "")
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
