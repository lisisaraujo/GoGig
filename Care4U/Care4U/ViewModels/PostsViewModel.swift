
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
    
    @Published var selectedLocation: String = "Worldwide"
    @Published var selectedCoordinates: CLLocationCoordinate2D?
    @Published var selectedDistance: Double = 0
    @Published var isWorldwideMode: Bool = false
    
    @Published var allPosts: [Post] = []
    @Published var selectedPost: Post?
    @Published var updateSuccess: Bool = false
    
    @Published var filteredPosts: [Post] = []
    
    @Published var bookmarkedPostsIds: [String] = []
    @Published var bookmarkedPosts: [Post] = []
    
    @Published var errorMessage: String?
    
    private var currentFilters: (type: PostTypeEnum?, searchText: String?, maxDistance: Double?, userLocation: CLLocationCoordinate2D?) = (nil, nil, nil, nil)
    
    init() {
        
        if firebaseManager.auth.currentUser != nil {
    
        }
        setupPostsListener()
    }
    
    func resetFilters() {
        currentFilters = (type: nil, searchText: nil, maxDistance: nil, userLocation: nil)
        selectedLocation = "Worldwide"
        selectedCoordinates = nil
        selectedDistance = 0
        isWorldwideMode = true
        applyCurrentFilters()
    }
    
    func filterPosts(selectedPostType: PostTypeEnum?, searchText: String?, maxDistance: Double?) {
        isWorldwideMode = false
        currentFilters = (selectedPostType, searchText, maxDistance, selectedCoordinates)
        applyCurrentFilters()
    }
    
    private func applyCurrentFilters() {
        if isWorldwideMode {
            self.filteredPosts = self.allPosts
            return
        }
        
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
                guard let postLat = post.latitude, let postLon = post.longitude else { return false }
                let postLocation = CLLocation(latitude: postLat, longitude: postLon)
                let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                let distance = postLocation.distance(from: userCLLocation) / 1000 // convert to km
                return distance <= maxDistance
            }
        }
        
        self.filteredPosts = filtered
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
    
    func createPost(type: String, title: String, description: String, selectedCategories: [CategoriesEnum], exchangeCoins: [String], isActive: Bool, latitude: Double?, longitude: Double?, postLocation: String) {
        
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
            longitude: longitude,
            postLocation: postLocation
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
    
    
    func sortPostsByDistance(from location: CLLocationCoordinate2D) {
        filteredPosts.sort { (post1, post2) -> Bool in
            guard let lat1 = post1.latitude, let lon1 = post1.longitude,
                  let lat2 = post2.latitude, let lon2 = post2.longitude else {
                return false
            }
            let location1 = CLLocation(latitude: lat1, longitude: lon1)
            let location2 = CLLocation(latitude: lat2, longitude: lon2)
            let userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            return location1.distance(from: userLocation) < location2.distance(from: userLocation)
        }
    }
    
    
    func addBookmark(postId: String) {
        Task {
            do {
                try await repo.addBookmark(postId: postId)
                await fetchBookmarkedPosts()
            } catch {
                handleError(error)
            }
        }
    }
    
    func removeBookmark(postId: String) {
        Task {
            do {
                try await repo.removeBookmark(postId: postId)
                await fetchBookmarkedPosts()
            } catch {
                handleError(error)
            }
        }
    }
    
    func fetchBookmarkedPosts() async {
        do {
            let fetchedPosts = try await repo.fetchBookmarkedPosts()
            await MainActor.run {
                self.bookmarkedPosts = fetchedPosts
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to fetch bookmarks: \(error.localizedDescription)"
            }
        }
    }
    
    func isPostBookmarked(_ postId: String) -> Bool {
        return bookmarkedPosts.contains { $0.id == postId }
    }
    
    
    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "An error occurred: \(error.localizedDescription)"
        }
    }
    
}
