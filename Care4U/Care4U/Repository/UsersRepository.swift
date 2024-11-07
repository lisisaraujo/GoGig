//
//  UsersRepository.swift
//  Care4U
//
//  Created by Lisis Ruschel on 01.11.24.
//

import Foundation
import FirebaseFirestore

class UsersRepository {
    
    private let firebaseManager = FirebaseManager.shared
    private let db = Firestore.firestore()
    
    @Published var selectedPost: Post?
    
    func fetchSelectedPost(with id: String) async {
          do {
              let document = try await db.collection(postsCollection).document(id).getDocument()
              
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
}

func addFavoritePost(for userId: String, postId: String) async throws {
    let userRef = db.collection("users").document(userId)
    
    // Use arrayUnion to add the post ID to the user's favorites
    try await userRef.updateData([
        "favorites": FieldValue.arrayUnion([postId])
    ])
}

func removeFavoritePost(for userId: String, postId: String) async throws {
    let userRef = db.collection("users").document(userId)
    
    // Use arrayRemove to remove the post ID from the user's favorites
    try await userRef.updateData([
        "favorites": FieldValue.arrayRemove([postId])
    ])
}

func fetchUserFavorites(userId: String) async throws -> [String] {
    let userDoc = try await db.collection("users").document(userId).getDocument()
    
    guard let data = userDoc.data(), let favorites = data["favorites"] as? [String] else {
        return []
    }
    
    return favorites
}


