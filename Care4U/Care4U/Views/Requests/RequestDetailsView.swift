//
//  RequestDetailsView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import SwiftUI

struct RequestDetailsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var serviceRequestViewModel: ServiceRequestViewModel
    @State private var showUserDetails = false
    @State private var showDeclineConfirmation = false
    @State private var showRatingView = false
    @State private var senderUser: User?
    let request: ServiceRequest

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Message:")
                    .font(.headline)
                Text(request.message ?? "No message provided")
                    .padding(.bottom)
                
                NavigationLink(destination: UserDetailsView(userId: senderUser?.id ?? "")) {
                    CreatorCardView(user: senderUser, title: "View Sender Profile")
                }

                .sheet(isPresented: $showUserDetails) {
                    if let senderId = senderUser?.id {
                        UserDetailsView(userId: senderId)
                    }
                }

                HStack {
                    if request.status == .pending && request.senderUserId != authViewModel.currentUser?.id {
                        Button("Accept") {
                            acceptRequest()
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Decline") {
                            showDeclineConfirmation = true
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    } else {
                        Text("Status: \(request.status.rawValue)")
                            .font(.headline)
                    }
                }
                
                if request.status == .accepted {
                          Text("Contact Information:")
                              .font(.headline)
                          Text(request.contactInfo ?? "No contact information provided")
                              .padding(.bottom)
                          
                          Button("Rate Service") {
                              showRatingView = true
                          }
                          .buttonStyle(.borderedProminent)
                          .sheet(isPresented: $showRatingView) {
                              if let senderUser = senderUser {
                                  AddRatingView(serviceProvider: senderUser, serviceRequestId: request.id!)
                              }
                          }
                      }
            }
            .padding()
        }.applyBackground()
        .navigationTitle("Request Details")
            .onAppear(perform: loadSenderDetails)
        .alert("Decline Request", isPresented: $showDeclineConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Decline", role: .destructive) {
                declineRequest()
            }
        } message: {
            Text("If you decline, this request will be removed from your history. Are you sure?")
        }
    }

    private func loadSenderDetails() {
        Task {
            await senderUser = authViewModel.fetchUser(with: request.senderUserId)
        }
    }

    private func acceptRequest() {
        serviceRequestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .accepted)
    }

    private func declineRequest() {
        serviceRequestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .declined)
    }
}


