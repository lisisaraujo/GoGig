//
//  Post.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import Foundation
import FirebaseFirestore

struct Post: Codable, Identifiable, Hashable{
    @DocumentID var id: String?
    let userId: String
    var type: String
    var title: String
    var description: String
    var isActive: Bool
    var exchangeCoins: [String]
    var categories: [String]
    var createdOn: Date
    
    init(id: String? = nil, userId: String, type: String, title: String, description: String, isActive: Bool, exchangeCoins: [String], categories: [String], createdOn: Date = Date()) {
        self.id = id
        self.userId = userId
        self.type = type
        self.title = title
        self.description = description
        self.isActive = isActive
        self.exchangeCoins = exchangeCoins
        self.categories = categories
        self.createdOn = createdOn
    }
}
