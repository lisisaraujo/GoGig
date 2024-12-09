//
//  PersonalTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct PersonalTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Binding var selectedTab: HomeTabEnum
    @State private var text: String? = "My Posts"

    var body: some View {
        NavigationStack {
            if authViewModel.isUserLoggedIn {
                ScrollView {
                    if let user = authViewModel.currentUser {
                        LazyVStack(spacing: 20) {
                            ProfileHeaderView(user: user, imageSize: 150, date: user.memberSince)
                            RatingView(rating: user.averageRating, reviewCount: user.reviewCount, userId: user.id!)
                                .environmentObject(postsViewModel)
                                .environmentObject(authViewModel)
                            AboutMeView(description: user.description)
                            PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == user.id }, text: $text)
                        }
                    }
                }
                .applyBackground()
                .navigationBarItems(trailing:
                                        NavigationLink(destination: MenuView( selectedTab: $selectedTab)
                        .environmentObject(authViewModel)
                                  ) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.accent)
                    }
                )
            } else {
                LoginOrRegisterView(onClose: {
                    selectedTab = .search
                })
                .environmentObject(authViewModel)
            }
        }
        .onAppear {
            Task {
                await authViewModel.checkAuth()
            }
        }
    }
}

#Preview {
    PersonalTabView(selectedTab: .constant(.personal))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
