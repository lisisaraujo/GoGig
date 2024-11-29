//
//  RequestStatus.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import SwiftUI


enum RequestStatus: String, Codable {
    case pending = "Pending"
    case accepted = "Accepted"
    case completed = "Completed"
    case declined = "Declined"
    case canceled = "Canceled"
}

 func statusColor(for status: RequestStatus) -> Color {
    switch status {
    case .accepted:
        return .green
    case .pending:
        return .yellow
    case .declined:
        return .red
    case .completed:
          return .buttonPrimary
    case .canceled:
          return .red
    }
}
