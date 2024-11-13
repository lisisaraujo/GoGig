//
//  Review.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import Foundation
import FirebaseFirestore

struct Review: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var userId: String
    var reviewerId: String
    var serviceRequestId: String?
    var review: String
    var rating: Double
    var timestamp: Date
    
    init(id: String? = nil, userId: String, reviewerId: String, serviceRequestId: String? = nil, review: String, rating: Double, timestamp: Date = Date()) {
        self.id = id
        self.userId = userId
        self.reviewerId = reviewerId
        self.serviceRequestId = serviceRequestId
        self.review = review
        self.rating = rating
        self.timestamp = timestamp
    }
}

