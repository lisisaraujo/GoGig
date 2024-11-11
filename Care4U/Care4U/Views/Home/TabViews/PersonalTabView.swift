//
//  PersonalTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI
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
                if let user = authViewModel.user {
                    VStack(alignment: .center, spacing: 20) {
                       
                        if let profilePicURL = user.profilePicURL, !profilePicURL.isEmpty {
                            AsyncImage(url: URL(string: profilePicURL)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                                } else if phase.error != nil {
                                 
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .foregroundColor(.gray)
                                } else {
                                   
                                    ProgressView()
                                        .frame(width: 150, height: 150)
                                }
                            }
                        } else {

                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.gray)
                        }

                      
                        VStack {
                            Text(user.fullName)
                                .font(.title)
                            Text(user.location)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

            
                        VStack(alignment: .leading) {
                            Text("About Me")
                                .font(.headline)
                            Text(user.description ?? "Tell us about yourself...")
                                .font(.body)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding()

                 
                        VStack(alignment: .leading) {
                            Text("My Ads")
                                .font(.headline)
                            ForEach(postsViewModel.allPosts.filter { $0.userId == user.id }, id: \.id) { post in
                                PostItemView(post: post)
                            }
                        }
                        .padding()
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
                       }
                   }
               }
           }

#Preview {
    PersonalTabView(selectedTab: .constant(.personal))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
