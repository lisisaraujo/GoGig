//
//  RequestNotificationView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import SwiftUI

struct RequestNotificationView: View {
    @ObservedObject var serviceRequestViewModel: ServiceRequestViewModel
    let request: ServiceRequest
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Request for: \(request.postId)")
                .font(.headline)
            Text("From: \(request.senderUserId)")
            Text("Status: \(request.status.rawValue)")
            
            if request.status == .pending {
                HStack {
                    Button("Accept") {
                        serviceRequestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .accepted)
                    }
                    Button("Decline") {
                        serviceRequestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .declined)
                    }
                }
            }
            
            if request.status == .accepted {
                Text("Contact Info: \(request.contactInfo ?? "Not provided")")
            }
        }
    }
}
