
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
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var isToastSuccess = false
    
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
    
    @MainActor
    func createPost(type: String, title: String, description: String, selectedCategories: [String], exchangeCoins: [String], isActive: Bool, latitude: Double?, longitude: Double?, postLocation: String) async {
        guard let userId = firebaseManager.userId else {
            self.toastMessage = "User not logged in. Cannot create post."
            self.isToastSuccess = false
            self.showToast = true
            return
        }

        let categoryStrings = selectedCategories.map { $0 }
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

        do {
            try await repo.createPost(post: newPost)
            self.updateSuccess = true
            self.toastMessage = "Post created successfully!"
            self.isToastSuccess = true
        } catch {
            self.updateSuccess = false
            self.toastMessage = "Failed to create post: \(error.localizedDescription)"
            self.isToastSuccess = false
        }
        self.showToast = true
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
    
    @MainActor
    func deleteSelectedPost(postId: String) async -> Bool {
        do {
            try await firebaseManager.database.collection(firebaseManager.postsCollectionName).document(postId).delete()
            self.toastMessage = "Post deleted successfully!"
            self.isToastSuccess = true
            self.showToast = true
            return true
        } catch {
            self.toastMessage = "Error deleting post: \(error.localizedDescription)"
            self.isToastSuccess = false
            self.showToast = true
            return false
        }
    }
    
    
    @MainActor
    func updatePost(type: String?, title: String?, description: String?, isActive: Bool?, exchangeCoins: [String]?, categories: [String]?, latitude: Double?, longitude: Double?, postLocation: String?) async {
        guard let postId = selectedPost?.id else {
            self.toastMessage = "No selected post to update."
            self.isToastSuccess = false
            self.showToast = true
            return
        }

        var updatedFields: [String: Any] = [:]

        if let type = type { updatedFields["type"] = type }
        if let title = title { updatedFields["title"] = title }
        if let description = description { updatedFields["description"] = description }
        if let isActive = isActive { updatedFields["isActive"] = isActive }
        if let exchangeCoins = exchangeCoins { updatedFields["exchangeCoins"] = exchangeCoins }
        if let categories = categories { updatedFields["categories"] = categories }
        if let latitude = latitude { updatedFields["latitude"] = latitude }
        if let longitude = longitude { updatedFields["longitude"] = longitude }
        if let postLocation = postLocation { updatedFields["postLocation"] = postLocation }

        do {
            try await repo.updatePost(postId: postId, updatedFields: updatedFields)

            // Update local state
            selectedPost?.type = type ?? selectedPost?.type ?? ""
            selectedPost?.title = title ?? selectedPost?.title ?? ""
            selectedPost?.description = description ?? selectedPost?.description ?? ""
            selectedPost?.isActive = isActive ?? selectedPost?.isActive ?? false
            selectedPost?.exchangeCoins = exchangeCoins ?? selectedPost?.exchangeCoins ?? []
            selectedPost?.categories = categories ?? selectedPost?.categories ?? []
            selectedPost?.latitude = latitude ?? selectedPost?.latitude
            selectedPost?.longitude = longitude ?? selectedPost?.longitude
            selectedPost?.postLocation = postLocation ?? selectedPost?.postLocation ?? ""

            // Update the post in allPosts
            if let index = allPosts.firstIndex(where: { $0.id == postId }) {
                allPosts[index] = selectedPost!
            }

            self.updateSuccess = true
            self.toastMessage = "Post updated successfully!"
            self.isToastSuccess = true
        } catch {
            self.updateSuccess = false
            self.toastMessage = "Error updating post: \(error.localizedDescription)"
            self.isToastSuccess = false
        }

        self.showToast = true
    }
    
    func addRandomPosts(postsList: [Post]){
        for post in postsList {
            Task {
              await createPost(
                    type: post.type,
                    title: post.title,
                    description: post.description,
                    selectedCategories: post.categories,
                    exchangeCoins: post.exchangeCoins,
                    isActive: post.isActive,
                    latitude: post.latitude,
                    longitude: post.longitude,
                    postLocation: post.postLocation
                )
            }
        }
      }

    
}


