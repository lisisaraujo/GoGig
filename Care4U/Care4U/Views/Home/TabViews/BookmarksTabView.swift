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
        NavigationStack {
            Group {
                if authViewModel.isUserLoggedIn {
                    ScrollView {
                        if isLoading {
                            ProgressView()
                        } else if !postsViewModel.bookmarkedPosts.isEmpty {
                            LazyVStack(spacing: 20) {
                                ForEach(postsViewModel.bookmarkedPosts) { post in
                                    PostItemView(post: post)
                                }
                            }
                        } else {
                            Text("No bookmarked posts")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                    .onAppear(perform: loadBookmarkedPosts)
                    .navigationTitle("Bookmarks")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    GoToLoginOrRegistrationSheetView(onClose: {
                        selectedTab = .search
                    })
                    .environmentObject(authViewModel)
                }
            }
        }
    }

    private func loadBookmarkedPosts() {
        isLoading = true
        Task {
            await postsViewModel.fetchBookmarkedPosts()
            isLoading = false
        }
    }
}

#Preview {
    BookmarksTabView(selectedTab: Binding.constant(.bookmark))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}

