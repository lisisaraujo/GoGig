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
        ZStack {
            ScrollView {
                if let user = user {
                    VStack(spacing: 20) {
                        ProfileHeaderView(user: user, imageSize: 150, date: user.memberSince)
                            .environmentObject(postsViewModel)
                            .environmentObject(authViewModel)
                        RatingView(rating: user.averageRating, reviewCount: user.reviewCount, userId: user.id!)
                            .environmentObject(postsViewModel)
                            .environmentObject(authViewModel)
                        AboutMeView(description: user.description)
                            .environmentObject(postsViewModel)
                            .environmentObject(authViewModel)
                        PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == userId }, text: $text)
                            .environmentObject(postsViewModel)
                            .environmentObject(authViewModel)
                    }
                    .padding()
                } else if !isLoading {
                    VStack {
                        Spacer()
                        Text("User not found")
                            .font(.headline)
                            .foregroundColor(.pink)
                        Spacer()
                    }
                    .padding()
                }
            }
            
            if isLoading {
                ProgressView()
                    .foregroundColor(Color.accent)
                    .scaleEffect(1.5)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
            }
        }
        .applyBackground()
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
