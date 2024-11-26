//
//  Request.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import FirebaseFirestore

struct ServiceRequest: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var senderUserId: String
    var recipientUserId: String
    var postId: String
    var status: ServiceRequestStatusEnum = .pending
    var timestamp: Date = Date()
    var completionDate: Date?
    var message: String?
    var contactInfo: String?
    
    init(id: String? = nil, senderUserId: String, recipientUserId: String, postId: String, status: ServiceRequestStatusEnum = .pending, timestamp: Date = Date(), completionDate: Date? = nil, message: String? = nil, contactInfo: String? = nil) {
        self.id = id
        self.senderUserId = senderUserId
        self.recipientUserId = recipientUserId
        self.postId = postId
        self.status = status
        self.timestamp = timestamp
        self.completionDate = completionDate
        self.message = message
        self.contactInfo = contactInfo
    }
}
