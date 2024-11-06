//
//  BookmarksTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct BookmarksTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Binding var selectedTab: HomeTabEnum
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if authViewModel.isUserLoggedIn {
                    if isLoading {
                        ProgressView()
                    } else if !postsViewModel.bookmarkedPosts.isEmpty {
                        ForEach(postsViewModel.bookmarkedPosts) { post in
                            PostItemView(post: post)
                        }
                    } else {
                        Text("No bookmarked posts")
                    }
                } else {
                    GoToLoginOrRegistrationSheetView(onClose: {
                        selectedTab = .search
                    })
                    .environmentObject(authViewModel)
                }
            }
            .onAppear {
                if authViewModel.isUserLoggedIn {
                    isLoading = true
                    Task {
                        await postsViewModel.fetchBookmarkedPosts()
                        isLoading = false
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    BookmarksTabView(selectedTab: Binding.constant(.bookmark))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}

