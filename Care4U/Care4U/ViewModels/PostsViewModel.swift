//
//  PostsViewModel.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import Foundation
import CoreLocation

@MainActor
class PostsViewModel: ObservableObject {
    
    private var firebaseManager = FirebaseManager.shared
    private let repo = PostsRepository()
    
    @Published var allPosts: [Post] = []
    @Published var selectedPost: Post?
    @Published var updateSuccess: Bool = false
    
    @Published var filteredPosts: [Post]?
    
    private var currentFilters: (type: PostTypeEnum?, searchText: String?, maxDistance: Double?, userLocation: CLLocationCoordinate2D?) = (nil, nil, nil, nil)
    
    init() {
        setupPostsListener()
    }
    
    private func setupPostsListener() {
        repo.listenToAllPosts { [weak self] allPosts, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Fetching all posts failed:", error.localizedDescription)
                return
            }
            
            guard let allPosts = allPosts else {
                print("Fetching all posts failed: No posts found")
                return
            }
            
            DispatchQueue.main.async {
                self.allPosts = allPosts
                self.applyCurrentFilters()
            }
        }
    }
    
    func createPost(type: String, title: String, description: String, selectedCategories: [CategoriesEnum], exchangeCoins: [String], isActive: Bool, latitude: Double, longitude: Double) {
        
        guard let userId = firebaseManager.userId else {
            print("User ID is not available")
            return
        }
        
        let categoryStrings = selectedCategories.map { $0.rawValue }
        
        let newPost = Post(
            userId: userId,
            type: type,
            title: title,
            description: description,
            isActive: isActive,
            exchangeCoins: exchangeCoins,
            categories: categoryStrings,
            createdOn: Date(),
            latitude: latitude,
            longitude: longitude
        )
        
        Task {
            do {
                try await repo.createPost(post: newPost)
                // The listener will automatically update allPosts and filteredPosts
                self.updateSuccess = true
            } catch {
                print("Failed to create post:", error.localizedDescription)
                self.updateSuccess = false
            }
        }
    }
    
    func getSelectedPost(with id: String) async {
        await repo.fetchSelectedPost(with: id)
        self.selectedPost = repo.selectedPost
    }
    
    func filterPosts(selectedPostType: PostTypeEnum?, searchText: String?, maxDistance: Double?, userLocation: CLLocationCoordinate2D?) {
        currentFilters = (selectedPostType, searchText, maxDistance, userLocation)
        applyCurrentFilters()
    }
    
    private func applyCurrentFilters() {
        var filtered = allPosts
        
        if let selectedPostType = currentFilters.type {
            filtered = filtered.filter { $0.type == selectedPostType.rawValue }
        }
        
        if let searchText = currentFilters.searchText, !searchText.isEmpty {
            filtered = filtered.filter { post in
                post.title.localizedCaseInsensitiveContains(searchText) ||
                post.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let maxDistance = currentFilters.maxDistance, let userLocation = currentFilters.userLocation {
            filtered = filtered.filter { post in
                let postLocation = CLLocation(latitude: post.latitude, longitude: post.longitude)
                let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                let distance = postLocation.distance(from: userCLLocation) / 1000 // Convert to km
                return distance <= maxDistance
            }
        }
        
        self.filteredPosts = filtered
    }
    
    func resetFilters() {
        currentFilters = (nil, nil, nil, nil)
        self.filteredPosts = self.allPosts
    }
}

