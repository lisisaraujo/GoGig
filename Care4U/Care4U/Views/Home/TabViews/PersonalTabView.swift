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
        NavigationView {
            ScrollView {
                if let user = authViewModel.currentUser {
                    VStack(spacing: 20) {
                        ProfileHeaderView(user: user, imageSize: 150)
                        AboutMeView(description: user.description)
                        MemberSinceView(date: user.memberSince)
                        PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == user.id }, selectedTab: $selectedTab)
                    }
                    .padding()
                } else {
                    GoToLoginOrRegistrationSheetView(onClose: {
                        selectedTab = .search
                    })
                    .environmentObject(authViewModel)
                }
            }
            .navigationTitle("Personal")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                showMenu = true
            }) {
                Image(systemName: "line.horizontal.3")
            })
            .sheet(isPresented: $showMenu) {
                MenuView(isPresented: $showMenu, shouldNavigateToEditProfile: $shouldNavigateToEditProfile)
            }
            .navigationDestination(isPresented: $shouldNavigateToEditProfile) {
                EditProfileView()
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
