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
    var latitude: Double?
    var longitude: Double?
    var memberSince: Date
    var profilePicURL: String?
    var favorites: [String]?

    var coordinate: (latitude: Double, longitude: Double)? {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        return (latitude, longitude)
    }

    init(id: String? = nil, email: String, fullName: String, birthDate: Date, location: String, latitude: Double? = nil, longitude: Double? = nil, memberSince: Date = Date(), profilePicURL: String? = nil, favorites: [String]? = nil) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.birthDate = birthDate
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.memberSince = memberSince
        self.profilePicURL = profilePicURL
        self.favorites = favorites
    }
}
