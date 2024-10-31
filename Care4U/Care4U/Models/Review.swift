//
//  Review.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import Foundation
import FirebaseFirestore

struct Review: Codable, Identifiable, Hashable{
    @DocumentID var id: String?
    let userId: String
    let reviewerId: String
    let review: String
    let rating: Double
    
    init(id: String? = nil, userId: String, reviewerId: String, review: String, rating: Double) {
        self.id = id
        self.userId = userId
        self.reviewerId = reviewerId
        self.review = review
        self.rating = rating
    }
}
