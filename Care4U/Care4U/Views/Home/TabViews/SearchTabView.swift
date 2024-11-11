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
    
    var body: some View {
        VStack {
            Picker("Post Type", selection: $selectedPostType) {
                Text("All").tag(nil as PostTypeEnum?)
                ForEach(PostTypeEnum.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type as PostTypeEnum?)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedPostType) { _, _ in
                filterPosts()
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search in \(postsViewModel.selectedLocation)", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    showLocationPicker = true
                }) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .onChange(of: searchText) { _, _ in
                filterPosts()
            }
            
            List(postsViewModel.filteredPosts) { post in
                PostItemView(post: post)
            }
            
            NavigationLink(destination: AddPostView(selectedTab: $selectedTab)) {
                Text("Add Post")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .onAppear {
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
