//
//  RequestsRepository.swift
//  Care4U
//
//  Created by Lisis Ruschel on 14.11.24.
//

import Foundation
import FirebaseFirestore

class RequestRepository {

    private let firebaseManager = FirebaseManager.shared
    
    func sendRequest(_ request: Request) async throws {
        try  firebaseManager.database.collection(firebaseManager.requestsCollectionName).addDocument(from: request)
    }
    
    func updateRequestStatus(requestId: String, newStatus: RequestStatus, isRated: Bool) async throws {
        try await firebaseManager.database.collection(firebaseManager.requestsCollectionName).document(requestId).updateData([
            "status": newStatus.rawValue,
            "isRated": isRated
        ])
    }

    func fetchRequest(requestId: String) async throws -> Request {
        let document = try await firebaseManager.database.collection(firebaseManager.requestsCollectionName).document(requestId).getDocument()
        return try document.data(as: Request.self)
    }

    func fetchSentRequests(for userId: String) async throws -> [Request] {
        let snapshot = try await firebaseManager.database.collection(firebaseManager.requestsCollectionName)
            .whereField("senderUserId", isEqualTo: userId)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Request.self) }
    }

    func fetchReceivedRequests(for userId: String) async throws -> [Request] {
        let snapshot = try await firebaseManager.database.collection(firebaseManager.requestsCollectionName)
            .whereField("recipientUserId", isEqualTo: userId)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Request.self) }
    }

    func fetchPendingRequests(for userId: String) async throws -> [Request] {
        let snapshot = try await firebaseManager.database.collection(firebaseManager.requestsCollectionName)
            .whereField("recipientUserId", isEqualTo: userId)
            .whereField("status", isEqualTo: "Pending")
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Request.self) }
    }

    func deleteRequest(requestId: String) async throws {
        try await firebaseManager.database.collection(firebaseManager.requestsCollectionName).document(requestId).delete()
    }
    
}
