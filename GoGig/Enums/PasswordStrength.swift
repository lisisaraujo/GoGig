//
//  PasswordStrength.swift
//  GoGig 
//
//  Created by Lisis Ruschel on 01.03.25.
//

import Foundation
import SwiftUI

enum PasswordStrength: String {
    case weak = "Weak"
    case medium = "Medium"
    case strong = "Strong"

    var color: Color {
        switch self {
        case .weak: return .red
        case .medium: return .orange
        case .strong: return .green
        }
    }
}

