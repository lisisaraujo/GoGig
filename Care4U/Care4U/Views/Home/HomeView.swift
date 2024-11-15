//
//  HomeView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var serviceRequestViewModel: ServiceRequestViewModel
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @State var selectedTab: HomeTabEnum = .search
    
    var body: some View {
  
            TabView(selection: $selectedTab) {
                SearchTabView(selectedTab: $selectedTab)
                    .environmentObject(postsViewModel)
                    .environmentObject(authViewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }.tag(HomeTabEnum.search)
                
                BookmarksTabView(selectedTab: $selectedTab)
                    .environmentObject(authViewModel)
                    .environmentObject(postsViewModel)
                    .tabItem {
                        Label("Bookmark", systemImage: "bookmark.fill")
                    }.tag(HomeTabEnum.bookmark)
                
                AddPostTabView(selectedTab: $selectedTab)
                    .environmentObject(postsViewModel)
                    .environmentObject(authViewModel)
                    .tabItem {
                        Label("Add", systemImage: "plus")
                    }.tag(HomeTabEnum.add)
                
                InboxTabView(selectedTab: $selectedTab)
                    .environmentObject(serviceRequestViewModel)
                    .environmentObject(inboxViewModel)
                    .environmentObject(authViewModel)
                    .tabItem {
                        Label("Inbox", systemImage: "envelope.fill")
                    }.tag(HomeTabEnum.inbox)
                
                PersonalTabView(selectedTab: $selectedTab)
                    .environmentObject(authViewModel)
                    .environmentObject(postsViewModel)
                    .tabItem {
                        Label("Personal", systemImage: "person.crop.circle")
                    }.tag(HomeTabEnum.personal)
            }
        }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel()) 
        .environmentObject(PostsViewModel())
        .environmentObject(ServiceRequestViewModel())
        .environmentObject(InboxViewModel())
}
