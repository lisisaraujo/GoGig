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
        NavigationView {
            ScrollView {
                if let user = authViewModel.selectedUser, authViewModel.selectedUser?.id == userId {
                    LazyVStack(spacing: 20) {
                        ProfileHeaderView(user: user, imageSize: 100)
                        AboutMeView(description: user.description)
                        MemberSinceView(date: user.memberSince)
                        ReviewsView(reviews: authViewModel.userReviews)
                        PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == userId }, selectedTab: $selectedTab)
                        
                        Button(action: {
                            // Action to reach out
                        }) {
                            Text("Reach Out")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(15)
                        }
                        .padding(.top)
                    }
                    .padding()
                } else {
                    ProgressView()
                }
            }
            .background(Color(.systemGroupedBackground))
        }
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
