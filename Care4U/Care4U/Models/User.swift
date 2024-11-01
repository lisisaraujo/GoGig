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
    var memberSince: Date
    var profilePicURL: String?
    var favorites: [String] 

    init(id: String? = nil, email: String, fullName: String, birthDate: Date, location: String, memberSince: Date = Date(), profilePicURL: String? = nil, favorites: [String] = []) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.birthDate = birthDate
        self.location = location
        self.memberSince = memberSince
        self.profilePicURL = profilePicURL
        self.favorites = favorites // Initialize favorites array
    }
}
