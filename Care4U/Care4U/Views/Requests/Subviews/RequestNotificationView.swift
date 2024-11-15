////
////  RequestNotificationView.swift
////  Care4U
////
////  Created by Lisis Ruschel on 13.11.24.
////
//
//import Foundation
//import SwiftUI
//
//struct RequestNotificationView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @ObservedObject var serviceRequestViewModel: ServiceRequestViewModel
//    let request: ServiceRequest
//    @State var userData: User?
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Request for: \(request.postId)")
//                .font(.headline)
//            Text("From: \(userData?.fullName ?? "Unknown")")
//            Text("Status: \(request.status.rawValue)")
//            
//            if request.status == .pending {
//                HStack {
//                    Button("Accept") {
//                        serviceRequestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .accepted)
//                    }
//                    Button("Decline") {
//                        serviceRequestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .declined)
//                    }
//                }
//            }
//            
//            if request.status == .accepted {
//                Text("Contact Info: \(request.contactInfo ?? "Not provided")")
//            }
//        }.onAppear(perform: {
//            Task {
//                userData = await authViewModel.fetchUser(with: request.senderUserId)
//            }
//        })
//    }
//}
