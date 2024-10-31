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
                        NavigationLink(destination: AddPostView().environmentObject(postsViewModel)
                            .environmentObject(authViewModel)) {
                            Text("Add Post")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth:.infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                            }
                    } else {
                       GoToLoginOrRegistrationSheetView()
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

