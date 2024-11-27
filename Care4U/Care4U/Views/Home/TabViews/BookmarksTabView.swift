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
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                if authViewModel.isUserLoggedIn {
                    ZStack {
                        ScrollView {
                            if !postsViewModel.bookmarkedPosts.isEmpty {
                                LazyVStack(spacing: 20) {
                                    PostsListView(posts: postsViewModel.bookmarkedPosts)
                                }
                            } else if !isLoading {
                                Text("No bookmarked posts")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        if isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                                .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                        }
                    }
                    .onAppear{
                        navigationPath = NavigationPath()
                        loadBookmarkedPosts()
                    }
                    .navigationTitle("Bookmarks")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    GoToLoginOrRegistrationSheetView(onClose: {
                        selectedTab = .search
                    })
                    .environmentObject(authViewModel)
                }
            }.applyBackground()
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

