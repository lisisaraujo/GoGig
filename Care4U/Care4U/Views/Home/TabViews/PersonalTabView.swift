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
    @State private var shouldNavigateToEditProfile = false
    
    var body: some View {
        NavigationStack {
            Group {
                if authViewModel.isUserLoggedIn {
                    ScrollView {
                        if let user = authViewModel.currentUser {
                            LazyVStack(spacing: 20) {
//                                ProfileHeaderView(user: user, imageSize: 150)
//                                AboutMeView(description: user.description)
                                
                                AboutMeView2(user: user, imageSize: 150)
                                MemberSinceView(date: user.memberSince)
                                PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == user.id })
                            }
                        }
                    }
                    .navigationTitle("Personal")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading: menuButton)
                    .sheet(isPresented: $showMenu) {
                        MenuView(isPresented: $showMenu, shouldNavigateToEditProfile: $shouldNavigateToEditProfile)
                    }
                    .navigationDestination(isPresented: $shouldNavigateToEditProfile) {
                        EditProfileView()
                            .environmentObject(authViewModel)
                    }
                } else {
                   
                    GoToLoginOrRegistrationSheetView(onClose: {
                        selectedTab = .search 
                    })
                    .environmentObject(authViewModel)
                }
            }
        }
        .onAppear {
            Task {
                await authViewModel.checkAuth()
            }
        }
    }

    private var menuButton: some View {
        Button(action: { showMenu = true }) {
            Image(systemName: "line.horizontal.3")
        }
    }
}

#Preview {
    PersonalTabView(selectedTab: .constant(.personal))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
