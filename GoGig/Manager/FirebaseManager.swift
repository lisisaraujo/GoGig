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
    let reviewsCollectionName = "reviews"
    let requestsCollectionName = "requests"
    let profilePicStorageRef = "profile_pictures"
    let failedSignupsCollectionName = "failed_signups"
    
    var userId: String? {
        auth.currentUser?.uid
    }
    
}
