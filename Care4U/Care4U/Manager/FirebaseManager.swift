//
//  FirebaseManager.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    let auth = Auth.auth()
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    let usersCollectionName = "users"
    let postsCollectionName = "posts"
    let userReviewsCollectionName = "userReviews"
    let chatsCollectionName = "chats"
    let profilePicStorageRef = "profile_pictures"
    
    var userId: String? {
        auth.currentUser?.uid
    }
    
}
