//
//  SearchTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI
import CoreLocation

struct SearchTabView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText = ""
    @State private var selectedPostType: PostTypeEnum?
    @State private var showLocationPicker = false
    @Binding var selectedTab: HomeTabEnum
    @State private var navigationPath = NavigationPath()
    @State private var text: String? = nil
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack{
                VStack(spacing: 10) {
                    
                    //   MARK: Uppet tab picker
                    
                    Picker("Post Type", selection: $selectedPostType) {
                        Text("All").tag(nil as PostTypeEnum?)
                        ForEach(PostTypeEnum.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type as PostTypeEnum?)
                        }
                    }
                    .pickerStyle(.segmented)
                    .background(Color.buttonPrimary.opacity(0.3))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    //   MARK: Searchbar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.gray)
                        TextField("Search in \(postsViewModel.selectedLocation)", text: $searchText)
                            .cornerRadius(50)
                        Button(action: {
                            showLocationPicker = true
                        }) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(Color.accent)
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    //   MARK: Posts list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if postsViewModel.filteredPosts.isEmpty {
                                VStack {
                                    Spacer()
                                    Text("No Posts in your area yet.")
                                        .foregroundColor(.secondary)
                                        .font(.headline)
                                    Spacer()
                                }
                            } else {
                                PostsListView(posts: postsViewModel.filteredPosts, text: $text) .environmentObject(postsViewModel)
                                    .environmentObject(authViewModel)
                                
                                                        List(postsViewModel.filteredPosts) { post in
                                
                                                        NavigationLink(destination: PostDetailsView(postId: post.id!)) {
                                                            PostItemView(post: post)
                            
                                                           }.listRowBackground(Color.clear)
                                                       }
                            
                                                       .scrollContentBackground(.hidden)
                                                       .background(Color.clear)
                                                    .listStyle(.plain)
                            }
                          
                        }
                    }
                }
                .applyBackground()
                

                    if postsViewModel.showToast {
                        ToastView(message: postsViewModel.toastMessage, isSuccess: postsViewModel.isToastSuccess)
                            .zIndex(2)
                            .animation(.easeInOut, value: postsViewModel.showToast)
                            .transition(.scale)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    postsViewModel.showToast = false
                                }
                            }
                    }
                
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: searchText) { _, _ in
                filterPosts()
            }
            .onChange(of: selectedPostType) { _, _ in
                filterPosts()
            }
            .onAppear {
                navigationPath = NavigationPath()
                filterPosts()
                //  postsViewModel.addRandomPosts(postsList: randomPostsDE)
                //      postsViewModel.addRandomPosts(postsList: randomPosts)
                
            }
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerView()
                    .presentationCornerRadius(50)
                    .presentationDetents([.medium])
            }
        }
    }
    
    private func filterPosts() {
        postsViewModel.filterPosts(
            selectedPostType: selectedPostType,
            searchText: searchText.isEmpty ? nil : searchText,
            maxDistance: postsViewModel.selectedDistance
        )
    }
}

#Preview {
    SearchTabView(selectedTab: .constant(.search))
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
