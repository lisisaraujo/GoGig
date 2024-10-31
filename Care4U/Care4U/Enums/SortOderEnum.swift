//
//  SortOderEnum.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import Foundation

enum SortOrder: Identifiable, CaseIterable {
    
    case title, titleDesc, newest
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .title: return "Titel"
        case .titleDesc: return "Titel desc."
        case .newest: return "Newest"
        }
    }
    
    // sortingFunction ist eine computed property, die als Wert eine Funktion speichert
    var sortingFunction: (Post, Post) -> Bool {
        switch self {
        case .title: return { $0.title < $1.title }
        case .titleDesc: return { $0.title > $1.title }
        case .newest: return { $0.createdOn > $1.createdOn }
        }
    }
    
    
}
