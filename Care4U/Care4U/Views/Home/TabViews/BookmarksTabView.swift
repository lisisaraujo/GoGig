//
//  BookmarksTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct BookmarksTabView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedTab: HomeTabEnum

    var body: some View {

            ScrollView {
                VStack(spacing: 20) {
                    if authViewModel.isUserLoggedIn {
                        Text("Hello, \(authViewModel.user?.fullName ?? "User")!")
                            .font(.largeTitle)
                            .padding()
                    } else {
                        GoToLoginOrRegistrationSheetView(onClose: {
                                                    selectedTab = .search
                                                })
                                                .environmentObject(authViewModel)
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
}

