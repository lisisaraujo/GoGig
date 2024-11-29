//
//  InboxViewModel.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import FirebaseFirestore
import Combine

class RequestViewModel: ObservableObject {
    private var firebaseManager = FirebaseManager.shared
    
    @Published var currentRequest: Request?
    @Published var sentRequests: [Request] = []
    @Published var errorMessage: String?
    
    init() {
        fetchSentRequests()
    }
    
    func sendRequest(recipientUserId: String, postId: String, postTitle: String, message: String?, contactInfo: String?) {
        guard let senderUserId = firebaseManager.userId else {
            self.errorMessage = "User not logged in"
            print("Error: User not logged in")
            return
        }
        
        let request = Request(senderUserId: senderUserId, recipientUserId: recipientUserId, postId: postId, postTitle: postTitle, message: message, contactInfo: contactInfo)
        
        do {
            try firebaseManager.database.collection(firebaseManager.requestsCollectionName).addDocument(from: request) { error in
                if let error = error {
                    self.errorMessage = "Error sending request: \(error.localizedDescription)"
                    print("Error sending request: \(error.localizedDescription)")
                } else {
                    print("Request sent successfully")
                    self.fetchSentRequests()
                }
            }
        } catch {
            self.errorMessage = "Error sending request: \(error.localizedDescription)"
            print("Error sending request: \(error.localizedDescription)")
        }
    }
    
    func updateRequestStatus(requestId: String, newStatus: RequestStatus, isRated: Bool = false) {
        firebaseManager.database.collection(firebaseManager.requestsCollectionName).document(requestId).updateData([
            "status": newStatus.rawValue,
            "isRated": isRated
        ]) { error in
            if let error = error {
                self.errorMessage = "Error updating request status: \(error.localizedDescription)"
            } else {
                self.fetchSentRequests()
            }
        }
    }
    
    func fetchRequest(requestId: String) {
        firebaseManager.database.collection(firebaseManager.requestsCollectionName).document(requestId).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    self.currentRequest = try document.data(as: Request.self)
                } catch {
                    self.errorMessage = "Error decoding request: \(error.localizedDescription)"
                }
            } else {
                self.errorMessage = "Request does not exist"
            }
        }
    }
    
    func fetchSentRequests() {
        guard let userId = firebaseManager.userId else {
            self.errorMessage = "User not logged in"
            return
        }
        
        firebaseManager.database.collection(firebaseManager.requestsCollectionName)
            .whereField("senderUserId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Error fetching sent requests: \(error.localizedDescription)"
                    return
                }
                self.sentRequests = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Request.self)
                } ?? []
            }
    }
    
    func cancelRequest(requestId: String) {
        updateRequestStatus(requestId: requestId, newStatus: .canceled)
    }
    
    func removeRequest(requestId: String) {
        firebaseManager.database.collection(firebaseManager.requestsCollectionName).document(requestId).delete { error in
            if let error = error {
                self.errorMessage = "Error removing request: \(error.localizedDescription)"
                print("Error removing request: \(error.localizedDescription)")
            } else {
                print("Request successfully removed")
                self.fetchSentRequests()
            }
        }
    }

}
