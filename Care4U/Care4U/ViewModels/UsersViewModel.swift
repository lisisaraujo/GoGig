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

    func fetchSelectedUser(with id: String) async {
        do {
            let document = try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(id).getDocument()
            
            guard document.exists else {
                print("No such document for selected user!")
                self.selectedUser = nil
                return
            }

            let fetchedUser = try document.data(as: User.self)
            self.selectedUser = fetchedUser
            
            // Fetch user reviews after fetching the user
            await fetchUserReviews(for: id)
        } catch {
            print("Error fetching selected user:", error)
            self.selectedUser = nil
        }
    }

    func fetchUserReviews(for userId: String) async {
        do {
            let reviewsQuery = firebaseManager.database.collection("reviews").whereField("userId", isEqualTo: userId)
            let snapshot = try await reviewsQuery.getDocuments()
            self.userReviews = snapshot.documents.compactMap { try? $0.data(as: Review.self) }
        } catch {
            print("Error fetching user reviews:", error.localizedDescription)
            self.userReviews = []
        }
    }
}
