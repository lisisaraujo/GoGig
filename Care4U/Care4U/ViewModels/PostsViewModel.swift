//
//  PostsViewModel.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {
    
    private var firebaseManager = FirebaseManager.shared
    private let repo = PostsRepository()
    
    @Published var allPosts: [Post] = []
    @Published var selectedPost: Post?
    @Published var updateSuccess: Bool = false
    
    @Published var filteredPosts: [Post]?
    
    init() {
        Task {
            await listenToAllPosts()
        }
    }
    
    func listenToAllPosts() async {
        repo.listenToAllPosts { allPosts, error in
            
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
            }
        }
    }
    
    func createPost(type: String, title: String, description: String, selectedCategories: [CategoriesEnum], exchangeCoins: [String], isActive: Bool) {
        
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
            createdOn: Date()
        )
        
        Task {
            do {
                try await repo.createPost(post: newPost)
                DispatchQueue.main.async {
                    self.allPosts.append(newPost)
                    self.updateSuccess = true
                }
            } catch {
                print("Failed to create post:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.updateSuccess = false
                }
            }
        }
    }
    
    func getSelectedPost(with id: String) async {
        await repo.fetchSelectedPost(with: id)
        
        self.selectedPost = repo.selectedPost
    }
    
    func filterPosts(selectedPostType: PostTypeEnum?, searchText: String) -> [Post] {
        let filtered = allPosts.filter { post in
            (selectedPostType == nil || post.type == selectedPostType?.rawValue) &&
            (searchText.isEmpty || post.title.localizedCaseInsensitiveContains(searchText) ||
             post.description.localizedCaseInsensitiveContains(searchText))
        }
        
        self.filteredPosts = filtered
        
        return filtered
    }
}

