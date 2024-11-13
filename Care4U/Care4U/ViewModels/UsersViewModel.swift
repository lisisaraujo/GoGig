//
//  UsersViewModel.swift
//  Care4U
//
//  Created by Lisis Ruschel on 12.11.24.
//

import Foundation
import CoreLocation

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var selectedUser: User?
    @Published var userReviews: [Review] = []
    private var firebaseManager = FirebaseManager.shared

}
