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

    func listenToSentRequests(for userId: String, completion: @escaping ([Request]?, Error?) -> Void) {
        firebaseManager.database.collection(firebaseManager.requestsCollectionName)
            .whereField("senderUserId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(nil, nil)
                    return
                }
                
                let requests = documents.compactMap { try? $0.data(as: Request.self) }
                completion(requests, nil)
            }
    }

    func listenToReceivedRequests(for userId: String, completion: @escaping ([Request]?, Error?) -> Void) {
        firebaseManager.database.collection(firebaseManager.requestsCollectionName)
            .whereField("recipientUserId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(nil, nil)
                    return
                }
                
                let requests = documents.compactMap { try? $0.data(as: Request.self) }
                completion(requests, nil)
            }
    }


    func deleteRequest(requestId: String) async throws {
        try await firebaseManager.database.collection(firebaseManager.requestsCollectionName).document(requestId).delete()
    }
    
    func listenToPendingRequests(for userId: String, completion: @escaping ([Request]?, Error?) -> Void) {
        let query = firebaseManager.database.collection(firebaseManager.requestsCollectionName)
            .whereField("recipientUserId", isEqualTo: userId)
            .whereField("status", isEqualTo: "Pending")
        
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(nil, nil)
                return
            }
            
            let requests = documents.compactMap { document -> Request? in
                try? document.data(as: Request.self)
            }
            completion(requests, nil)
        }
    }

    
}
