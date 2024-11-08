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
    @State private var selectedDistance: Double = 0
    @State private var isDistanceFilterActive = true
    @Binding var selectedTab: HomeTabEnum
    @State private var showLocationPicker = false
    @State private var selectedLocation: String?
    @State private var selectedCoordinates: CLLocationCoordinate2D?
    
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                TextField("Search in \(selectedLocation ?? authViewModel.user?.location ?? "your area")", text: $searchText)
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
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
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
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            }
        }
        .onAppear {
            filterPosts()
        }
        .sheet(isPresented: $showLocationPicker) {
            LocationPickerView(selectedLocation: $selectedLocation, selectedCoordinates: $selectedCoordinates, selectedDistance: $selectedDistance)
        }
        .onChange(of: selectedLocation) { _, _ in
            filterPosts()
        }
        .onChange(of: selectedDistance) { _, _ in
            filterPosts()
        }
    }
    
    private func filterPosts() {
        let location: CLLocationCoordinate2D?
        if let selectedCoordinates = selectedCoordinates {
            location = selectedCoordinates
        } else if let userLocation = authViewModel.user?.locationCoordinates {
            location = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
        } else {
            location = nil
        }
        
        postsViewModel.filterPosts(
            selectedPostType: selectedPostType,
            searchText: searchText.isEmpty ? nil : searchText,
            maxDistance: isDistanceFilterActive ? (selectedDistance == 1000 ? nil : selectedDistance) : nil,
            userLocation: location
        )
    }

}

#Preview {
    SearchTabView(selectedTab: .constant(.search))
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
