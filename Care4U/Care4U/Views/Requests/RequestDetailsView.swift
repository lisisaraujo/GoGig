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
    @EnvironmentObject var requestViewModel: RequestViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showUserDetails = false
    @State private var showDeleteConfirmation = false
    @State private var showDeclineConfirmation = false
    @State private var showRatingView = false
    @State var senderUser: User?
    @State var request: Request
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Request for: \(request.postTitle)")
                    .font(.headline)
                    .padding(.bottom)
                
                if let senderUser = senderUser {
                    NavigationLink(destination: UserDetailsView(userId: senderUser.id!)) {
                        HStack {
                            Spacer()
                            ProfileHeaderView(user: senderUser, imageSize: 100)
                            Spacer()
                        }
                    }
                }
                
                Text(request.message ?? "No message provided")
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 150)
                    .background(Color("surfaceBackground"))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(statusColor(for: request.status))
                        .frame(width: 10, height: 10)
                    
                    Text(request.status.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    Text(request.timestamp, formatter: dateFormatter)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if request.status == .accepted || request.status == .completed {
                    Text("Contact:")
                        .font(.headline)
                    
                    Text(request.contactInfo ?? "No contact information provided")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.buttonPrimary.opacity(0.6))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                
                Spacer()
                
                if request.status == .accepted && !request.isRated {
                    Button("Rate Service") {
                        showRatingView = true
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.yellow.opacity(0.7))
                    .foregroundColor(.background)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .sheet(isPresented: $showRatingView) {
                                         AddRatingView(serviceProvider: senderUser!, requestId: request.id!)
                                     }
                } else if request.status == .pending && request.senderUserId != authViewModel.currentUser?.id {
                    HStack(spacing: 20) {
                        Button(action: {
                            acceptRequest()
                        }) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("background"))
                                .frame(width: 60, height: 60)
                                .background(Color.buttonPrimary)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        
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
        }
        .applyBackground()
        .navigationTitle("Request Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            showDeleteConfirmation = true
        }) {
            Image(systemName: "trash.fill")
                .foregroundColor(.red)
        })
        .alert("Delete Request", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteRequest()
            }
        } message: {
            Text("Are you sure you want to delete this request? This action cannot be undone.")
        }
        .alert("Decline Request", isPresented: $showDeclineConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Decline", role: .destructive) {
                declineRequest()
            }
        } message: {
            Text("If you decline, this request will be removed from your history. Are you sure?")
        }
        .onAppear {
            loadSenderDetails()
        }
        .onChange(of: request.status) { oldStatus ,newStatus in
            if newStatus != oldStatus {
                loadSenderDetails()
            }
        }
    }
    
    private func loadSenderDetails() {
        Task {
            senderUser = await authViewModel.fetchUserData(with: request.senderUserId)
        }
    }
    
    private func acceptRequest() {
        requestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .accepted)
        request.status = .accepted
    }
    
    private func deleteRequest() {
        requestViewModel.removeRequest(requestId: request.id!)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func declineRequest() {
        requestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .declined)
        request.status = .declined
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

#Preview {
    RequestDetailsView(senderUser: sampleUser, request: sampleRequest)
        .environmentObject(AuthViewModel())
        .environmentObject(RequestViewModel())
}
