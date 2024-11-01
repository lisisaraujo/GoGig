//
//  PostsRepository.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import Foundation
import FirebaseFirestore

class PostsRepository {
    
    private let firebaseManager = FirebaseManager.shared
    @Published var selectedPost: Post?

    func createPost(post: Post) async throws {
        let document = firebaseManager.database.collection(firebaseManager.postsCollectionName).document()
        try document.setData(from: post)
    }

    func listenToAllPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        firebaseManager.database.collection(firebaseManager.postsCollectionName).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let documents = snapshot?.documents else {
                completion(nil, nil)
                return
            }

            let posts = documents.compactMap { document -> Post? in
                try? document.data(as: Post.self)
            }
            completion(posts, nil)
        }
    }
    
    func fetchSelectedPost(with id: String) async {
          do {
              let document = try await firebaseManager.database.collection(firebaseManager.postsCollectionName).document(id).getDocument()
              
              guard document.exists else {
                  print("No such document!")
                  self.selectedPost = nil
                  return
              }
              
              let fetchedPost = try document.data(as: Post.self)
              self.selectedPost = fetchedPost
          } catch {
              print("Error fetching post:", error)
              self.selectedPost = nil
          }
      }
    
    func addFavoritePost(for userId: String, postId: String) async throws {
            let userRef = firebaseManager.database.collection("users").document(userId)
            
        
            try await userRef.updateData([
                "favorites": FieldValue.arrayUnion([postId]) //using union array makes me not have to check for duplicates in the array first
            ])
        }

        func removeFavoritePost(for userId: String, postId: String) async throws {
            let userRef = firebaseManager.database.collection("users").document(userId)
            
        
            try await userRef.updateData([
                "favorites": FieldValue.arrayRemove([postId])
            ])
        }

        func fetchUserFavorites(userId: String) async throws -> [String] {
            let userDoc = try await firebaseManager.database.collection("users").document(userId).getDocument()
            
            guard let data = userDoc.data(), let favorites = data["favorites"] as? [String] else {
                return []
            }
            
            return favorites
        }
    
}
