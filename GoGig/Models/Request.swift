//
//  Request.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import FirebaseFirestore

struct Request: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var senderUserId: String
    var recipientUserId: String
    var postId: String
    var postTitle: String
    var status: RequestStatus = .pending
    var timestamp: Date = Date()
    var completionDate: Date?
    var message: String
    var contactInfo: String
    var isRated: Bool
    
    init(id: String? = nil, senderUserId: String, recipientUserId: String, postId: String, postTitle: String, status: RequestStatus = .pending, timestamp: Date = Date(), completionDate: Date? = nil, message: String, contactInfo: String, isRated: Bool = false) {
        self.id = id
        self.senderUserId = senderUserId
        self.recipientUserId = recipientUserId
        self.postId = postId
        self.postTitle = postTitle
        self.status = status
        self.timestamp = timestamp
        self.completionDate = completionDate
        self.message = message
        self.contactInfo = contactInfo
        self.isRated = isRated
    }
}
