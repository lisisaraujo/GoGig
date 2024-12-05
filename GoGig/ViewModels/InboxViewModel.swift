////
////  InboxViewModel.swift
////  Care4U
////
////  Created by Lisis Ruschel on 13.11.24.
////
//
//import Foundation
//import FirebaseFirestore
//import Combine
//
//
//class InboxViewModel: ObservableObject {
//    private var firebaseManager = FirebaseManager.shared
//    
//    @Published var receivedRequests: [Request] = []
//    @Published var pendingRequests: [Request] = []
//    @Published var errorMessage: String?
//    
//    init() {
//        fetchReceivedRequests()
//        getPendingRequests()
//    }
//    
//    func fetchReceivedRequests() {
//        guard let userId = firebaseManager.userId else {
//            self.errorMessage = "User not logged in"
//            return
//        }
//        
//        
//        firebaseManager.database.collection(firebaseManager.requestsCollectionName)
//            .whereField("recipientUserId", isEqualTo: userId)
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    self.errorMessage = "Error fetching requests: \(error.localizedDescription)"
//                    return
//                }
//                self.receivedRequests = querySnapshot?.documents.compactMap { document in
//                    try? document.data(as: Request.self)
//                } ?? []
//                self.errorMessage = nil
//            }
//    }
//    
//    func getPendingRequests() {
//            guard let userId = firebaseManager.userId else {
//                self.errorMessage = "User not logged in"
//                return
//            }
//            firebaseManager.database.collection(firebaseManager.requestsCollectionName)
//                .whereField("recipientUserId", isEqualTo: userId).whereField("status", isEqualTo: "Pending")
//                .addSnapshotListener { querySnapshot, error in
//                    if let error = error {
//                        self.errorMessage = "Error fetching requests: \(error.localizedDescription)"
//                        return
//                    }
//                    self.pendingRequests = querySnapshot?.documents.compactMap { document in
//                        try? document.data(as: Request.self)
//                    } ?? []
//                    self.errorMessage = nil
//                }
//        }
//    
//    func updateRequestStatus(requestId: String, newStatus: RequestStatus) {
//        firebaseManager.database.collection(firebaseManager.requestsCollectionName)
//            .document(requestId).updateData(["status": newStatus.rawValue]) { error in
//                if let error = error {
//                    self.errorMessage = "Failed to update status: \(error.localizedDescription)"
//                }
//            }
//    }
//    
//    func acceptRequest(requestId: String) {
//        updateRequestStatus(requestId: requestId, newStatus: .accepted)
//    }
//    
//    func declineRequest(requestId: String) {
//        updateRequestStatus(requestId: requestId, newStatus: .declined)
//    }
//    
//    func markRequestAsCompleted(requestId: String) {
//        firebaseManager.database.collection(firebaseManager.requestsCollectionName)
//            .document(requestId).updateData([
//                "status": RequestStatus.completed.rawValue,
//                "completionDate": Timestamp(date: Date())
//            ]) { error in
//                if let error = error {
//                    self.errorMessage = "Failed to mark request as completed: \(error.localizedDescription)"
//                }
//            }
//    }
//    
//    
//}
