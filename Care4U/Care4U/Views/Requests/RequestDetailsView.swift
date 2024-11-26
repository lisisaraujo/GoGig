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
    @Environment(\.presentationMode) var presentationMode
    @State private var showUserDetails = false
    @State private var showDeleteConfirmation = false
    @State private var showDeclineConfirmation = false
    @State private var showRatingView = false
    @State private var senderUser: User?
    let request: ServiceRequest

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
               
                   HStack(alignment: .top, spacing: 12) {
                       Spacer()
                           Circle()
                               .fill(statusColor(for: request.status))
                               .frame(width: 10, height: 10)
                           
                           Text(request.status.rawValue)
                               .font(.subheadline)
                               .foregroundColor(.secondary)
                 
                       }
               
                if let user = senderUser {
                    HStack(alignment: .top, spacing: 16) {
                        if let profilePicURL = user.profilePicURL, let url = URL(string: profilePicURL) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            }
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text(user.fullName)
                                .font(.headline)
                                .fontWeight(.bold)

                            Text(request.timestamp, formatter: dateFormatter)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }
                }

                VStack(alignment: .leading, spacing: 12) {

                    Text(request.message ?? "No message provided")
                        .padding()
                        .background(Color("surfaceBackground"))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    
                    if request.status == .accepted {
                            Text("Contact:")
                                .font(.headline)

                            Text(request.contactInfo ?? "No contact information provided")
                                .padding()
                                .background(Color("accent").opacity(0.6))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                            Button("Rate Service") {
                                showRatingView = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.accent)
                            .sheet(isPresented: $showRatingView) {
                                if let senderUser = senderUser {
                                    AddRatingView(serviceProvider: senderUser, serviceRequestId: request.id!)
                                }
                            }
                        }
                    }
                if request.status == .pending && request.senderUserId != authViewModel.currentUser?.id {
                    Spacer()
                    HStack(spacing: 20) {
                        Button(action: {
                            acceptRequest()
                        }) {
                         
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("background"))
                     
                            .frame(width: 60, height: 60)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        
                        Spacer()
                        Button(action: {
                            showDeclineConfirmation = true
                        }) {
                            
                                Image(systemName: "xmark")
                                    .foregroundColor(Color("background"))
                       
                            .frame(width: 60, height: 60)
                            .background(Color.pink)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                    }

                }
            }
            .padding()
        }.applyBackground()

        .navigationTitle("Request Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            showDeleteConfirmation = true
        }) {
            Image(systemName: "trash.fill")
                .foregroundColor(.red)
        })
        .onAppear(perform: loadSenderDetails)
        .alert("Delete Request", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteRequest()
            }
        } message: {
            Text("Are you sure you want to delete this request? This action cannot be undone.")
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

    private func deleteRequest() {
        serviceRequestViewModel.removeRequest(requestId: request.id!)
        presentationMode.wrappedValue.dismiss()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}


#Preview {
    RequestDetailsView(request: ServiceRequest(
        id: "12345",
        senderUserId: "user123",
        recipientUserId: "user456",
        postId: "post789",
        status: .accepted,
        timestamp: Date(),
        completionDate: nil,
        message: "I would like to request your service for cleaning my garden.",
        contactInfo: "contact@example.com"
    ))
        .environmentObject(AuthViewModel())
        .environmentObject(ServiceRequestViewModel())
}
