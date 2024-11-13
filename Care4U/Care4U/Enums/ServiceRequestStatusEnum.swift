//
//  ServiceRequestStatusEnum.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation


enum ServiceRequestStatusEnum: String, Codable {
    case pending = "Pending"
    case accepted = "Accepted"
    case completed = "Completed"
    case declined = "Declined"
    case canceled = "Canceled"
}
