//
//  RequestViewModel.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
class RequestViewModel: ObservableObject {
    
    private var firebaseManager = FirebaseManager.shared
    private let repository = RequestRepository()
    
    @Published var currentRequest: Request?
    @Published var sentRequests: [Request] = []
    @Published var errorMessage: String?
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var isToastSuccess = false
    
    @Published var receivedRequests: [Request] = []
    @Published var pendingRequests: [Request] = []
    
    init() {
        fetchSentRequests()
        fetchReceivedRequests()
        getPendingRequests()
    }
    
    func sendRequest(recipientUserId: String, postId: String, postTitle: String, message: String?, contactInfo: String?) {
        guard let senderUserId = firebaseManager.userId else {
            self.errorMessage = "User not logged in"
            return
        }
        
        let request = Request(senderUserId: senderUserId, recipientUserId: recipientUserId, postId: postId, postTitle: postTitle, message: message, contactInfo: contactInfo)
        
        Task {
            do {
                try await repository.sendRequest(request)
                 fetchSentRequests()
            } catch {
                self.errorMessage = "Error sending request: \(error.localizedDescription)"
            }
        }
    }
    
    func updateRequestStatus(requestId: String, newStatus: RequestStatus, isRated: Bool = false) {
        Task {
            do {
                try await repository.updateRequestStatus(requestId: requestId, newStatus: newStatus, isRated: isRated)
                 fetchSentRequests()
            } catch {
                self.errorMessage = "Error updating request status: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchSentRequests() {
        guard let userId = firebaseManager.userId else {
            self.errorMessage = "User not logged in"
            return
        }
        
        Task {
            do {
                let requests = try await repository.fetchSentRequests(for: userId)
                self.sentRequests = requests
            } catch {
                self.errorMessage = "Error fetching sent requests: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchReceivedRequests() {
        guard let userId = firebaseManager.userId else {
            self.errorMessage = "User not logged in"
            return
        }
        
        Task {
            do {
                let requests = try await repository.fetchReceivedRequests(for: userId)
                self.receivedRequests = requests
                self.errorMessage = nil
            } catch {
                self.errorMessage = "Error fetching received requests: \(error.localizedDescription)"
            }
        }
    }

    func getPendingRequests() {
        guard let userId = firebaseManager.userId else {
            self.errorMessage = "User not logged in"
            return
        }
        
        Task {
            do {
                let requests = try await repository.fetchPendingRequests(for: userId)
                self.pendingRequests = requests
                self.errorMessage = nil
            } catch {
                self.errorMessage = "Error fetching pending requests: \(error.localizedDescription)"
            }
        }
    }

    func cancelRequest(requestId: String) {
        updateRequestStatus(requestId: requestId, newStatus: .canceled)
    }

    func deleteRequest(requestId: String) {
        Task {
            do {
                try await repository.deleteRequest(requestId: requestId)
                self.toastMessage = "Request deleted successfully."
                self.isToastSuccess = true
            } catch {
                self.toastMessage = "Failed to delete the request: \(error.localizedDescription)"
                self.isToastSuccess = false
            }
            self.showToast = true
        }
    }

    func acceptRequest(requestId: String) {
        updateRequestStatus(requestId: requestId, newStatus: .accepted)
    }

    func declineRequest(requestId: String) {
        updateRequestStatus(requestId: requestId, newStatus: .declined)
    }

    
    @MainActor
    func markRequestAsCompleted(requestId: String) {
        firebaseManager.database.collection(firebaseManager.requestsCollectionName)
            .document(requestId).updateData([
                "status": RequestStatus.completed.rawValue,
                "completionDate": Timestamp(date: Date())
            ]) { error in
                if let error = error {
                    self.errorMessage = "Failed to mark request as completed: \(error.localizedDescription)"
                }
            }
    }
}
