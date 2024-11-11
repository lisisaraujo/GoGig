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
    @State var selectedTab: HomeTabEnum = .search
    @State private var showMenu = false
    
    var body: some View {
        NavigationStack {
         
                TabView(selection: $selectedTab) {
                    if !showMenu {
                    SearchTabView(selectedTab: $selectedTab)
                        .environmentObject(postsViewModel)
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }.tag(HomeTabEnum.search)
                    
                    BookmarksTabView(selectedTab: $selectedTab)
                        .tabItem {
                            Label("Bookmark", systemImage: "bookmark.fill")
                        }.tag(HomeTabEnum.bookmark)
                    
                    InboxTabView(selectedTab: $selectedTab)
                        .tabItem {
                            Label("Inbox", systemImage: "envelope.fill")
                        }.tag(HomeTabEnum.inbox)
                    
                    PersonalTabView(selectedTab: $selectedTab, showMenu: $showMenu)
                        .tabItem {
                            Label("Personal", systemImage: "person.crop.circle")
                        }.tag(HomeTabEnum.personal)
                }
            } 
            
        }
        
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel()) 
        .environmentObject(PostsViewModel())
}
