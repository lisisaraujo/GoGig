//
//  Chat.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import Foundation
import FirebaseFirestore

struct Chat: Codable, Identifiable, Hashable{
    @DocumentID var id: String?
    let memberId1: String
    let memberId2: String
    let messages: [Message]
    
    init(id: String? = nil, memberId1: String, memberId2: String, messages: [Message]) {
        self.id = id
        self.memberId1 = memberId1
        self.memberId2 = memberId2
        self.messages = messages
    }
}




