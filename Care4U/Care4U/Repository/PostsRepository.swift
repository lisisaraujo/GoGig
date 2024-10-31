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
    private let db = Firestore.firestore()
    private let postsCollection = "posts"
    
    @Published var selectedPost: Post?

    func createPost(post: Post) async throws {
        let document = db.collection(postsCollection).document()
        try await document.setData(from: post)
    }

    func listenToAllPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        db.collection(postsCollection).addSnapshotListener { snapshot, error in
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
