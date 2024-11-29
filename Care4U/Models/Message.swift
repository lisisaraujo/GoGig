//
//  Message.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import Foundation
import FirebaseFirestore

struct Message: Codable, Identifiable, Hashable{
    @DocumentID var id: String?
    let senderId: String
    let receiverId: String
    let text: String
    var date: Date = Date()
    
    init(id: String? = nil, senderId: String, receiverId: String, text: String, date: Date) {
        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId
        self.text = text
        self.date = date
    }
}
