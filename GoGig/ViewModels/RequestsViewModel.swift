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
    @Published var requests: [Request]?
    @Published var selectedRequestID: String?
    @Published var sentRequests: [Request] = []
    @Published var errorMessage: String?
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var isToastSuccess = false
    
    @Published var receivedRequests: [Request] = []
    @Published var pendingRequests: [Request] = []
    
    init() {
setupListeners()
        
    }
    
     func setupListeners() {
        guard let userId = firebaseManager.userId else {
            self.errorMessage = "User not logged in"
            return
        }

        setupSentRequestsListener(userId: userId)
        setupReceivedRequestsListener(userId: userId)
        setupPendingRequestsListener()

    }
    
    
    func sendRequest(recipientUserId: String, postId: String, postTitle: String, message: String, contactInfo: String) {
        guard let senderUserId = firebaseManager.userId else {
            
            Task { @MainActor in
                self.toastMessage = "Error: User not logged in."
                self.isToastSuccess = false
                self.showToast = true
            }
            return
        }
        
        let request = Request(
            senderUserId: senderUserId,
            recipientUserId: recipientUserId,
            postId: postId,
            postTitle: postTitle,
            message: message,
            contactInfo: contactInfo
        )
        
        Task {
            do {
                try await repository.sendRequest(request)
                await MainActor.run {
                    self.toastMessage = "Request sent successfully!"
                    self.isToastSuccess = true
                    self.showToast = true
                }
            } catch {
                await MainActor.run {
                    self.toastMessage = "Failed to send request: \(error.localizedDescription)"
                    self.isToastSuccess = false
                    self.showToast = true
                }
            }
        }
    }
    
    
    func updateRequestStatus(requestId: String, newStatus: RequestStatus, isRated: Bool = false) {
        Task {
            do {
                try await repository.updateRequestStatus(requestId: requestId, newStatus: newStatus, isRated: isRated)
            } catch {
                self.errorMessage = "Error updating request status: \(error.localizedDescription)"
            }
        }
    }
    
    private func setupSentRequestsListener(userId: String) {
            repository.listenToSentRequests(for: userId) { [weak self] requests, error in
                guard let self = self else { return }

                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error listening to sent requests: \(error.localizedDescription)"
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.sentRequests = requests ?? []
                }
            }
        }

        private func setupReceivedRequestsListener(userId: String) {
            repository.listenToReceivedRequests(for: userId) { [weak self] requests, error in
                guard let self = self else { return }

                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error listening to received requests: \(error.localizedDescription)"
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.receivedRequests = requests ?? []
                }
            }
        }
    
    
    func setupPendingRequestsListener() {
        guard let userId = firebaseManager.userId else {
            self.errorMessage = "User not logged in"
            return
        }
        
        repository.listenToPendingRequests(for: userId) { [weak self] requests, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Listening to pending requests failed:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch pending requests: \(error.localizedDescription)"
                }
                return
            }
            
            guard let requests = requests else {
                print("No pending requests found.")
                return
            }
            
            DispatchQueue.main.async {
                self.pendingRequests = requests
                self.errorMessage = nil
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
                await MainActor.run {
                    self.toastMessage = "Request deleted successfully."
                    self.isToastSuccess = true
                    self.showToast = true
                }
            } catch {
                await MainActor.run {
                    self.toastMessage = "Failed to delete the request: \(error.localizedDescription)"
                    self.isToastSuccess = false
                    self.showToast = true
                }
            }
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
