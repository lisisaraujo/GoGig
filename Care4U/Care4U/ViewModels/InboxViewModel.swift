//
//  InboxViewModel.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import FirebaseFirestore
import Combine


class InboxViewModel: ObservableObject {
    private var firebaseManager = FirebaseManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var receivedRequests: [ServiceRequest] = []
    @Published var errorMessage: String?
    
    init() {
        fetchReceivedRequests()
    }
    
    func fetchReceivedRequests() {
        guard let userId = firebaseManager.userId else {
            self.errorMessage = "User not logged in"
            print("Error: User not logged in")
            return
        }
        
        print("Fetching requests for user: \(userId)")
        
        firebaseManager.database.collection(firebaseManager.serviceRequestsCollectionName)
            .whereField("recipientUserId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Error fetching requests: \(error.localizedDescription)"
                    print("Error fetching requests: \(error.localizedDescription)")
                    return
                }
                self.receivedRequests = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: ServiceRequest.self)
                } ?? []
                print("Received requests: \(self.receivedRequests.count)")
            }
    }
    
    func updateRequestStatus(requestId: String, newStatus: ServiceRequestStatusEnum) {
        firebaseManager.database.collection(firebaseManager.serviceRequestsCollectionName)
            .document(requestId).updateData(["status": newStatus.rawValue]) { error in
                if let error = error {
                    self.errorMessage = "Failed to update status: \(error.localizedDescription)"
                }
            }
    }
    
    func acceptRequest(requestId: String) {
        updateRequestStatus(requestId: requestId, newStatus: .accepted)
    }
    
    func declineRequest(requestId: String) {
        updateRequestStatus(requestId: requestId, newStatus: .declined)
    }
    
    func markRequestAsCompleted(requestId: String) {
        firebaseManager.database.collection(firebaseManager.serviceRequestsCollectionName)
            .document(requestId).updateData([
                "status": ServiceRequestStatusEnum.completed.rawValue,
                "completionDate": Timestamp(date: Date())
            ]) { error in
                if let error = error {
                    self.errorMessage = "Failed to mark request as completed: \(error.localizedDescription)"
                }
            }
    }
}
