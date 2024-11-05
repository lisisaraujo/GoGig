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


    var body: some View {

            ScrollView {
                VStack(spacing: 20) {
                    if authViewModel.user != nil {
                        
                    } else {
                        GoToLoginOrRegistrationSheetView(onClose: {
                                                    selectedTab = .search
                                                })
                                                .environmentObject(authViewModel)
                    }
                }
                .navigationTitle("Personal")
                .navigationBarTitleDisplayMode(.inline)
            }
    
        }
    }


#Preview {
    PersonalTabView(selectedTab: .constant(.personal))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}

