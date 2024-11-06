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
    @State private var selectedDistance: Double = 50
    @State private var isDistanceFilterActive = false
    @State private var showDistanceSlider = false
    @Binding var selectedTab: HomeTabEnum
    
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
            
            TextField("Search", text: $searchText)
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
                Button(action: {
                    withAnimation {
                        isDistanceFilterActive.toggle()
                        showDistanceSlider = isDistanceFilterActive
                    }
                    filterPosts()
                }) {
                    HStack {
                        Image(systemName: isDistanceFilterActive ? "location.fill" : "location")
                        Text(isDistanceFilterActive ? "Remove Distance Filter" : "Add Distance Filter")
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(isDistanceFilterActive ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isDistanceFilterActive ? .white : .primary)
                    .cornerRadius(8)
                }
                
                Spacer()
                
                if isDistanceFilterActive {
                    Text("\(Int(selectedDistance)) km")
                }
            }
            .padding(.horizontal)
            
            if showDistanceSlider {
                Slider(value: $selectedDistance, in: 1...100, step: 1)
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
            postsViewModel.resetFilters()
        }
    }
    
    private func filterPosts() {
        Task {
            let userLocation: CLLocationCoordinate2D?
            if isDistanceFilterActive,
               let latitude = authViewModel.user?.latitude,
               let longitude = authViewModel.user?.longitude {
                userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                userLocation = nil
            }
            
             postsViewModel.filterPosts(
                selectedPostType: selectedPostType,
                searchText: searchText.isEmpty ? nil : searchText,
                maxDistance: isDistanceFilterActive ? selectedDistance : nil,
                userLocation: userLocation
            )
        }
    }
}

#Preview {
    SearchTabView(selectedTab: .constant(.search))
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
