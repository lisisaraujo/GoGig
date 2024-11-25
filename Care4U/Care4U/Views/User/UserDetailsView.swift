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
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                    RatingView(rating: user.averageRating, reviewCount: user.reviewCount)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                    AboutMeView(description: user.description)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                    MemberSinceView(date: user.memberSince)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                    ReviewsScrollView(reviews: authViewModel.userReviews)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                    PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == userId })
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
            await authViewModel.fetchSelectedUser(with: userId)
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

#Preview {
    let authViewModel = AuthViewModel()
    let postsViewModel = PostsViewModel()
    
    // Mock data for preview
    let mockUser = User(
        id: "1",
        email: "test@example.com",
        fullName: "Test User",
        birthDate: Date(),
        location: "Test Location",
        description: "This is a test user.",
        latitude: 52.5200,
        longitude: 13.4050,
        memberSince: Date(),
        profilePicURL: nil
    )
    
    authViewModel.selectedUser = mockUser
    postsViewModel.allPosts = [
        Post(
            id: "1",
            userId: "1",
            type: "Type",
            title: "Sample Post",
            description: "This is a sample post description.",
            isActive: true,
            exchangeCoins: ["Coin1", "Coin2"],
            categories: ["Category1", "Category2"],
            createdOn: Date(),
            latitude: 52.5200,
            longitude: 13.4050,
            postLocation: "Berlin"
        )
    ]
    
    return UserDetailsView(userId: "1")
        .environmentObject(postsViewModel)
        .environmentObject(authViewModel)
}
