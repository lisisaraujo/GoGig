//
//  SampleData.swift
//  Care4U
//
//  Created by Lisis Ruschel on 10.11.24.
//

import Foundation

let sampleUser = User(
    id: "12345",
    email: "sampleuser@example.com",
    fullName: "John Doe",
    birthDate: Calendar.current.date(byAdding: .year, value: -30, to: Date())!, // 30 years ago
    location: "New York, USA",
    description: "A software developer who loves coding and coffee.",
    latitude: 40.7128,
    longitude: -74.0060,
    memberSince: Date(),
    profilePicURL: "https://example.com/path/to/profile/pic.jpg",
    bookmarks: ["post1", "post2", "post3"]
)
