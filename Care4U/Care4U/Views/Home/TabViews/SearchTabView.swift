//
//  SearchTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI
import CoreLocation

struct SearchTabView: View {
    @State private var searchText = ""
    @State private var selectedPostType: PostTypeEnum?
    @State private var errorMessage: String?
    @State private var selectedDistance: Double = 10
    @State private var isDistanceFilterActive = true
    @Binding var selectedTab: HomeTabEnum
    
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            // filter based on selected tab
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
            
            // filter based search word that matches title or description
            TextField("Search in \(authViewModel.user?.location ?? "your area")", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText) { _, _ in
                    filterPosts()
                }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            HStack {
                Text("Radius: \(selectedDistance == 1000 ? "Worldwide" : "\(Int(selectedDistance)) km")")
                Spacer()
                Toggle("", isOn: $isDistanceFilterActive)
            }
            .padding(.horizontal)
            
            // filter based on selected radius distance
            if isDistanceFilterActive {
                Slider(value: $selectedDistance, in: 1...1000, step: 1)
                    .padding(.horizontal)
                    .onChange(of: selectedDistance) { _, _ in
                        filterPosts()
                    }
            }
            
            List(postsViewModel.filteredPosts ?? postsViewModel.allPosts) { post in
                PostItemView(post: post)
            }
            
            NavigationLink(destination: AddPostView(selectedTab: $selectedTab).environmentObject(postsViewModel)
                .environmentObject(authViewModel)) {
                Text("Add Post")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            }
        }
        .onAppear {
            filterPosts()
        }
    }
    
    private func filterPosts() {
        guard let userLocation = authViewModel.user?.locationCoordinates else {
            errorMessage = "User location not available"
            return
        }
        
        errorMessage = nil
        
        postsViewModel.filterPosts(
            selectedPostType: selectedPostType,
            searchText: searchText.isEmpty ? nil : searchText,
            maxDistance: isDistanceFilterActive ? (selectedDistance == 1000 ? nil : selectedDistance) : nil,
            userLocation: CLLocationCoordinate2D(latitude:  userLocation.latitude, longitude: userLocation.longitude)
        )
    }
}
#Preview {
    SearchTabView(selectedTab: .constant(.search))
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
