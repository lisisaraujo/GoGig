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
    @State private var showSenderProfile = false
    @State private var showDeclineConfirmation = false
    @State private var showRatingView = false
    @State private var senderUser: User?
    let request: ServiceRequest

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Request Details")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Message:")
                    .font(.headline)
                Text(request.message ?? "No message provided")
                    .padding(.bottom)

                Button(action: { showSenderProfile = true }) {
                    SenderCardView(senderUser: senderUser)
                }
                .sheet(isPresented: $showSenderProfile) {
                    if let senderId = senderUser?.id {
                        UserDetailsView(userId: senderId, selectedTab: .constant(.inbox))
                    }
                }

                if request.status == .accepted {
                    Text("Contact Information:")
                        .font(.headline)
                    Text(request.contactInfo ?? "No contact information provided")
                        .padding(.bottom)
                }

                HStack {
                    if request.status == .pending {
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
        }
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
            await authViewModel.fetchSelectedUser(with: request.senderUserId)
            senderUser = authViewModel.selectedUser
        }
    }

    private func acceptRequest() {
        serviceRequestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .accepted)
    }

    private func declineRequest() {
        serviceRequestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .declined)
        // Optionally, remove the request from the database
        // serviceRequestViewModel.removeRequest(requestId: request.id!)
    }
}

struct SenderCardView: View {
    let senderUser: User?

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: senderUser?.profilePicURL ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.circle")
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(senderUser?.fullName ?? "Unknown Sender")
                    .font(.headline)
                Text("View Profile")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}
