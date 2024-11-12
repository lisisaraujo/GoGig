//
//  InboxChatsView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct InboxChatsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showLoginOrRegistrationSheet: Bool
    @Binding var selectedTab: HomeTabEnum

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if authViewModel.isUserLoggedIn {
                        Text("Hello, \(authViewModel.currentUser?.fullName ?? "User")!")
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
}

#Preview {
    InboxChatsView(showLoginOrRegistrationSheet: .constant(true), selectedTab: .constant(.search))
        .environmentObject(AuthViewModel())
}
