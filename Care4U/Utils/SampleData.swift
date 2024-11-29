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
    birthDate: Calendar.current.date(byAdding: .year, value: -30, to: Date())!,
    location: "New York, USA",
    description: "A software developer who loves coding and coffee.",
    latitude: 40.7128,
    longitude: -74.0060,
    memberSince: Date(),
    profilePicURL: "https://example.com/path/to/profile/pic.jpg",
    bookmarks: ["post1", "post2", "post3"]
)


let sampleRequest = Request(
    id: "12345",
    senderUserId: "user123",
    recipientUserId: "user456",
    postId: "post789",
    postTitle: "Cat sitting",
    status: .accepted,
    timestamp: Date(),
    completionDate: nil,
    message: "I would like to request your service for cleaning my garden.",
    contactInfo: "contact@example.com"
)

let samplePost =  Post(
    id: "1",
    userId: "1",
    type: "Type",
    title: "Sample Post",
    description: "This is a sample post description.",
    isActive: true,
    exchangeCoins: ["Coin1", "Coin2"],
    categories: ["Category1", "Category2"],
    createdOn: Date(),
    latitude: 52.5200,
    longitude: 13.4050,
    postLocation: "Berlin"
)
