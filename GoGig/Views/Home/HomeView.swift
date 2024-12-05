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
    @EnvironmentObject var requestViewModel: RequestViewModel
    @State var selectedTab: HomeTabEnum = .search
    
    var body: some View {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    SearchTabView(selectedTab: $selectedTab)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                        .tag(HomeTabEnum.search)
                    
                    BookmarksTabView(selectedTab: $selectedTab)
                        .environmentObject(authViewModel)
                        .environmentObject(postsViewModel)
                        .tag(HomeTabEnum.bookmark)
                    
                    AddPostTabView(selectedTab: $selectedTab)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                        .tag(HomeTabEnum.add)
                    
                    InboxTabView(selectedTab: $selectedTab)
                        .environmentObject(requestViewModel)
                        .environmentObject(authViewModel)
                        .tag(HomeTabEnum.inbox)
                    
                    PersonalTabView(selectedTab: $selectedTab)
                        .environmentObject(authViewModel)
                        .environmentObject(postsViewModel)
                        .tag(HomeTabEnum.personal)
                }
                .overlay(
                    CustomTabBar(selectedTab: $selectedTab, inboxCount: requestViewModel.pendingRequests.count)
                       
                        .padding(.bottom, 0),
                    alignment: .bottom
                )
            }
            .edgesIgnoringSafeArea(.bottom)
        }
}

struct CustomTabBar: View {
    @Binding var selectedTab: HomeTabEnum
    let inboxCount: Int
    
    var body: some View {
        HStack {
            ForEach(HomeTabEnum.allCases, id: \.self) { tab in
                Spacer()
                TabBarItem(tab: tab, selectedTab: $selectedTab, inboxCount: inboxCount)
                Spacer()
            }
        }
        .padding(20)
        .background(Color.buttonPrimary.opacity(0.3))
        .cornerRadius(50)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct TabBarItem: View {
    let tab: HomeTabEnum
    @Binding var selectedTab: HomeTabEnum
    let inboxCount: Int
    
    var body: some View {
        VStack {
            Image(systemName: tab.iconName)
                .foregroundColor(selectedTab == tab ? .textPrimary : .textPrimary.opacity(0.5))
                .font(.title2)
            
            Text(tab.title)
                .font(.caption2)
                .foregroundColor(selectedTab == tab ? .textPrimary : .textPrimary.opacity(0.5))
        }
        .overlay(
            Group {
                if tab == .inbox && inboxCount > 0 {
                    Text("\(inboxCount)")
                        .font(.caption2)
                        .foregroundColor(.textPrimary)
                        .padding(5)
                        .background(Color.accent)
                        .clipShape(Circle())
                        .offset(x: 15, y: -20)
                }
            }
        )
        .onTapGesture {
            selectedTab = tab
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
        .environmentObject(RequestViewModel())
}
