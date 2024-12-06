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
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                .cornerRadius(10)
                .padding(.horizontal)
                
                //   MARK: Posts list
                ZStack {
                    if postsViewModel.filteredPosts.isEmpty {
                        VStack {
                            Spacer()
                            Text("No Posts in your area yet.")
                                .foregroundColor(.secondary)
                                .font(.headline)
                            Spacer()
                        }
                    } else {
                        List(postsViewModel.filteredPosts) { post in
                            
                            NavigationLink(destination: PostDetailsView(postId: post.id!)) {
                                PostItemView(post: post)
                                    .frame(maxWidth: .infinity)
                                
                            }.listRowBackground(Color.clear)
                        }
                            
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .listStyle(.plain)
                    }
                    
                    if postsViewModel.showToast {
                                ToastView(message: postsViewModel.toastMessage, isSuccess: postsViewModel.isToastSuccess)
                                    .zIndex(2)
                                    .animation(.easeInOut, value: postsViewModel.showToast)
                                    .transition(.move(edge: .top))
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            postsViewModel.showToast = false
                                        }
                                    }
                            }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .applyBackground()
        
        }
        .onChange(of: searchText) { _, _ in
            filterPosts()
        }
        .onChange(of: selectedPostType) { _, _ in
            filterPosts()
        }
        .onAppear {
            navigationPath = NavigationPath()
            filterPosts()
        }
        .sheet(isPresented: $showLocationPicker) {
            LocationPickerView()
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
