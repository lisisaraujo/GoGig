//
//  User.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var email: String
    var fullName: String
    var birthDate: Date
    var location: String
    var description: String?
    var latitude: Double?
    var longitude: Double?
    var memberSince: Date
    var profilePicURL: String?
    
    // ratings and reviews
    var averageRating: Double = 0.0
    var reviewCount: Int = 0
    
    // bookmarked posts and requests
    var bookmarks: [String]?
    var sentRequests: [String]?
    var receivedRequests: [String]? 
    
    init(id: String? = nil, email: String, fullName: String, birthDate: Date, location: String, description: String? = nil, latitude: Double? = nil, longitude: Double? = nil, memberSince: Date, profilePicURL: String? = nil, bookmarks: [String]? = nil) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.birthDate = birthDate
        self.location = location
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.memberSince = memberSince
        self.profilePicURL = profilePicURL
        self.bookmarks = bookmarks
    }
}
