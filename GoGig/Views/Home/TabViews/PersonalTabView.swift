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
    @State private var showMenu = false
    @State private var navigationPath = NavigationPath()
    @State private var text: String? = "Posts"
    
    @State private var sheetBackgroundColor: Color = .clear

    var body: some View {
        NavigationStack(path: $navigationPath) {
            if authViewModel.isUserLoggedIn {
                ScrollView {
                    if let user = authViewModel.currentUser {
                        LazyVStack(spacing: 20) {
                            ProfileHeaderView(user: user, imageSize: 150, date: user.memberSince)
                            AboutMeView(description: user.description)
                            PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == user.id }, text: $text)
                        }
                    }
                }.applyBackground()
                .navigationBarItems(trailing:
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            showMenu = true
                        }
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.buttonPrimary)
                    }
                )
                .sheet(isPresented: $showMenu) {
                        MenuView(isPresented: $showMenu, navigationPath: $navigationPath)
                        .presentationBackground(sheetBackgroundColor)
                        .presentationDetents([.medium])
                       
                }
                .navigationDestination(for: String.self) { destination in
                    switch destination {
                    case "EditProfile":
                        EditProfileView()
                            .environmentObject(authViewModel)
                    default:
                        EmptyView()
                    }
                }
            } else {
                LoginOrRegisterView(onClose: {
                    selectedTab = .search
                })
                .environmentObject(authViewModel)
            }
        }
        .onAppear {
            navigationPath = NavigationPath()
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
