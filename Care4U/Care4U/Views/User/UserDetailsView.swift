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
    @Binding var selectedTab: HomeTabEnum
    
    var body: some View {
        ScrollView {
            if let user = authViewModel.selectedUser, authViewModel.selectedUser?.id == userId {
                VStack(spacing: 20) {
                    ProfileHeaderView(user: user, imageSize: 120)
                    RatingView(rating: user.averageRating, reviewCount: user.reviewCount)
                    AboutMeView(description: user.description)
                    MemberSinceView(date: user.memberSince)
                    ReviewsScrollView(reviews: authViewModel.userReviews)
                    PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == userId }, selectedTab: $selectedTab)
                }
                .padding()
            } else {
                ProgressView()
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("User Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await authViewModel.fetchSelectedUser(with: userId)
            }
        }
    }
}


#Preview {
    UserDetailsView(userId: "", selectedTab: .constant(.search))
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
