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
                Picker("Post Type", selection: $selectedPostType) {
                    Text("All").tag(nil as PostTypeEnum?)
                    ForEach(PostTypeEnum.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type as PostTypeEnum?)
                    }
                }
                .pickerStyle(.segmented)
                .accentColor(.textPrimary)
                .background(Color.buttonPrimary.opacity(0.5))
                .cornerRadius(50)
                .padding(.horizontal)
                
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
                
                List(postsViewModel.filteredPosts) { post in
                    Button(action: {
                        navigationPath.append(post.id!)
                    }) {
                        PostItemView(post: post)
                            .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .listStyle(.plain)
            }
            .applyBackground()
            .navigationDestination(for: String.self) { postId in
                PostDetailsView(postId: postId)
            }
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
