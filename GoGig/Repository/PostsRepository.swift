//
//  PostsRepository.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import Foundation
import FirebaseFirestore
import CoreLocation

class PostsRepository {
    
    private let firebaseManager = FirebaseManager.shared
    @Published var selectedPost: Post?
    private var userLocation: CLLocationCoordinate2D?
    
    
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
    
    func addBookmark(postId: String) async throws {
        guard let userId = firebaseManager.userId else { throw NSError(domain: "User not logged in", code: 0, userInfo: nil) }
        let userRef = firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId)
        try await userRef.updateData([
            "favorites": FieldValue.arrayUnion([postId])
        ])
    }
    
    func removeBookmark(postId: String) async throws {
        guard let userId = firebaseManager.userId else { throw NSError(domain: "User not logged in", code: 0, userInfo: nil) }
        let userRef = firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId)
        try await userRef.updateData([
            "favorites": FieldValue.arrayRemove([postId])
        ])
    }
    
    func fetchBookmarkedPosts() async throws -> [Post] {
        guard let userId = firebaseManager.userId else { throw NSError(domain: "User not logged in", code: 0, userInfo: nil) }
        let userDoc = try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId).getDocument()
        
        guard let data = userDoc.data(), let bookmarkIds = data["favorites"] as? [String] else {
            return []
        }
        
        let postsCollection = firebaseManager.database.collection(firebaseManager.postsCollectionName)
        
        var bookmarkedPosts: [Post] = []
        
        for id in bookmarkIds {
            if let doc = try? await postsCollection.document(id).getDocument(),
               let post = try? doc.data(as: Post.self) {
                bookmarkedPosts.append(post)
            }
        }
        
        return bookmarkedPosts
    }
    
    
    // obviously used AI help for this
    func fetchPostsWithinRadius(center: CLLocationCoordinate2D, radiusInKm: Double) async throws -> [Post] {
        let earthRadiusInKm: Double = 6371
        let lat = center.latitude
        let lon = center.longitude
        let angularRadius = radiusInKm / earthRadiusInKm
        
        let minLat = lat - angularRadius * 180 / .pi
        let maxLat = lat + angularRadius * 180 / .pi
        let minLon = lon - angularRadius * 180 / (.pi * cos(lat * .pi / 180))
        let maxLon = lon + angularRadius * 180 / (.pi * cos(lat * .pi / 180))
        
        let query = firebaseManager.database.collection(firebaseManager.postsCollectionName)
            .whereField("latitude", isGreaterThan: minLat)
            .whereField("latitude", isLessThan: maxLat)
            .whereField("longitude", isGreaterThan: minLon)
            .whereField("longitude", isLessThan: maxLon)
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Post.self) }
    }
    
    func deleteSelectedPost(postId: String) async throws {
        do {
            try await firebaseManager.database.collection(firebaseManager.postsCollectionName).document(postId).delete()
            print("Post data deleted successfully")
        } catch {
            print("Error deleting Post data: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updatePost(postId: String, updatedFields: [String: Any]) async throws {
        guard !updatedFields.isEmpty else { return }
        
        let postRef = firebaseManager.database.collection(firebaseManager.postsCollectionName).document(postId)
        try await postRef.updateData(updatedFields)
    }
}


