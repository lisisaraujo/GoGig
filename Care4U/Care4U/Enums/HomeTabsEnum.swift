//
//  HomeTabsEnum.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import Foundation


enum HomeTabEnum: String, CaseIterable {
    case search, bookmark, add, inbox, personal
    
    var iconName: String {
        switch self {
        case .search: return "magnifyingglass"
        case .bookmark: return "bookmark.fill"
        case .add: return "plus"
        case .inbox: return "envelope.fill"
        case .personal: return "person.crop.circle"
        }
    }
    
    var title: String {
        self.rawValue.capitalized
    }
}
