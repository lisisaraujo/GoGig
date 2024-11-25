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
    @State private var isShowingMenu = false
    @State private var shouldNavigateToEditProfile = false
    @State private var isFlipped = false
    
    var body: some View {
        NavigationStack {
            if authViewModel.isUserLoggedIn {
                ZStack {
                    if !isShowingMenu {
                        personalView
                            .rotation3DEffect(
                                .degrees(isFlipped ? 180 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )
                    } else {
                        MenuView(
                            isPresented: $isShowingMenu,
                            shouldNavigateToEditProfile: $shouldNavigateToEditProfile,
                            isFlipped: $isFlipped
                        )
                        .rotation3DEffect(
                            .degrees(isFlipped ? 0 : -180),
                            axis: (x: 0, y: 1, z: 0)
                        )
                    }
                }.applyBackground()
                .navigationDestination(isPresented: $shouldNavigateToEditProfile) {
                    EditProfileView()
                        .environmentObject(authViewModel)
                }
                .onAppear {
                    Task {
                        await authViewModel.checkAuth()
                    }
                }
            } else {
                GoToLoginOrRegistrationSheetView(onClose: {
                    selectedTab = .search
                })
                .environmentObject(authViewModel)
            }
        }
    }
    
    private var personalView: some View {
        ScrollView {
            if let user = authViewModel.currentUser {
                LazyVStack(spacing: 20) {
                    ProfileHeaderView(user: user, imageSize: 150)
                    AboutMeView(description: user.description)
                    MemberSinceView(date: user.memberSince)
                    PostsListView(posts: postsViewModel.allPosts.filter { $0.userId == user.id })
                }
            }
        }
        .navigationTitle("Personal")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            Button(action: {
                withAnimation(.easeInOut(duration: 0.8)) {
                    isFlipped.toggle() // Flip before showing menu
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isShowingMenu = true
                    }
                }
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.accent)
            }
        )
    }
}

#Preview {
    PersonalTabView(selectedTab: .constant(.personal))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
