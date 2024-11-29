////
////  UserRepository.swift
////  Care4U
////
////  Created by Lisis Ruschel on 14.11.24.
////
//
//import Firebase
//import FirebaseFirestore
//
//class UserRepository {
//    private let db = Firestore.firestore()
//    private let storage = Storage.storage()
//    
//    func fetchUser(with id: String) async throws -> User {
//        let document = try await db.collection("users").document(id).getDocument()
//        guard let user = try? document.data(as: User.self) else {
//            throw NSError(domain: "UserRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
//        }
//        return user
//    }
//    
//    func updateUser(_ user: User) async throws {
//        guard let id = user.id else { throw NSError(domain: "UserRepository", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is missing"]) }
//        try await db.collection("users").document(id).setData(from: user)
//    }
//    
//    func fetchUserReviews(for userId: String) async throws -> [Review] {
//        let snapshot = try await db.collection("reviews")
//            .whereField("userId", isEqualTo: userId)
//            .order(by: "timestamp", descending: true)
//            .getDocuments()
//        
//        return snapshot.documents.compactMap { try? $0.data(as: Review.self) }
//    }
//    
//    func uploadProfilePicture(_ image: UIImage, for userID: String) async throws -> String {
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            throw NSError(domain: "UserRepository", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
//        }
//        
//        let storageRef = storage.reference().child("profile_pictures/\(userID).jpg")
//        _ = try await storageRef.putDataAsync(imageData)
//        let url = try await storageRef.downloadURL()
//        return url.absoluteString
//    }
//    
//    func deleteUser(userId: String) async throws {
//        try await db.collection("users").document(userId).delete()
//    }
//    
//    func deleteUserPosts(userId: String) async throws {
//        let querySnapshot = try await db.collection("posts").whereField("userId", isEqualTo: userId).getDocuments()
//        for document in querySnapshot.documents {
//            try await document.reference.delete()
//        }
//    }
//    
//    func deleteStorageData(userId: String) async throws {
//        let storageRef = storage.reference().child("profile_pictures/\(userId).jpg")
//        try await storageRef.delete()
//    }
//    
//    func addReview(_ review: Review) async throws {
//        let _ = try await db.collection("reviews").addDocument(from: review)
//        try await updateUserRating(userId: review.userId, newRating: review.rating)
//    }
//    
//    private func updateUserRating(userId: String, newRating: Double) async throws {
//        let userRef = db.collection("users").document(userId)
//        let document = try await userRef.getDocument()
//        
//        guard document.exists else { throw NSError(domain: "UserRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"]) }
//        
//        let currentAverage = document.data()?["averageRating"] as? Double ?? 0.0
//        let currentCount = document.data()?["reviewCount"] as? Int ?? 0
//        
//        let newCount = currentCount + 1
//        let newAverage = ((currentAverage * Double(currentCount)) + newRating) / Double(newCount)
//        
//        try await userRef.updateData([
//            "averageRating": newAverage,
//            "reviewCount": newCount
//        ])
//    }
//}
