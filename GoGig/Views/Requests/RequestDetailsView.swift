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
    @Environment(\.dismiss) private var dismiss
    @State private var showUserDetails = false
    @State private var showDeleteConfirmation = false
    @State private var showDeclineConfirmation = false
    @State private var showRatingView = false
    @State var senderUser: User?
    let request: Request
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Request for: \(request.postTitle)")
                            .font(.headline)
                            .padding(.bottom)
                            .foregroundColor(Color.textPrimary)
                        
                        Text(request.message)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(20)
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
                        }.padding(.bottom, 50)
                        
                        if request.status == .accepted || request.status == .completed {
                            VStack(alignment: .leading) {
                                Text("Contact:")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)
                                
                                Text(request.contactInfo)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.secondary.opacity(0.1))
                                    .cornerRadius(20)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            }.padding(.bottom, 50)
                        }
                        
                        if request.status == .accepted && !request.isRated && request.senderUserId != authViewModel.currentUser?.id {
                            Button("Rate Service") {
                                showRatingView = true
                            }

                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.buttonPrimary.opacity(0.9))
                            .foregroundColor(.textPrimary)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            .sheet(isPresented: $showRatingView) {
                                AddRatingView(serviceProvider: senderUser!, requestId: request.id!)
                                    .presentationCornerRadius(50)
                                    .presentationDetents([.medium])
                            }
                        } else if request.status == .pending && request.senderUserId != authViewModel.currentUser?.id {
                            VStack {
                                Spacer()
                                HStack(spacing: 50) {
                                    Spacer()
                                    
                                    Button(action: {
                                        acceptRequest()
                                    }) {
                                        VStack {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color("background"))
                                                .frame(width: 60, height: 60)
                                                .background(Color.buttonPrimary)
                                                .clipShape(Circle())
                                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                            
                                            Text("Accept")
                                                .font(.caption)
                                                .foregroundColor(Color.textPrimary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        showDeclineConfirmation = true
                                    }) {
                                        VStack {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.background)
                                                .frame(width: 60, height: 60)
                                                .background(.accent)
                                                .clipShape(Circle())
                                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                            
                                            Text("Decline")
                                                .font(.caption)
                                                .foregroundColor(Color.textPrimary)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                Spacer()
                            }
                        }
                        
                        Spacer()
                        
                        if let senderUser = senderUser {
                            
                            NavigationLink(destination: UserDetailsView(userId: senderUser.id!)) {
                                NavigationLink(destination: UserDetailsView(userId: senderUser.id ?? "")) {
                                    CreatorCardView(user: senderUser, title: "View Profile")
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.vertical, 10)
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
                
            }      .onAppear {
                loadSenderDetails()
            }
            .onChange(of: request.status) { oldStatus ,newStatus in
                if newStatus != oldStatus {
                    loadSenderDetails()
                }
            }

            
            if authViewModel.showToast {
                ToastView(message: authViewModel.toastMessage, isSuccess: authViewModel.isToastSuccess)
                    .animation(.easeInOut, value: authViewModel.showToast)
                    .transition(.move(edge: .top))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            authViewModel.showToast = false
                        }
                    }
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
        
    }
    
    private func deleteRequest() {
        requestViewModel.deleteRequest(requestId: request.id!)
            dismiss()
        
    }
    
    private func declineRequest() {
        requestViewModel.updateRequestStatus(requestId: request.id!, newStatus: .declined)
        
    }
    
}


#Preview {
    RequestDetailsView(request: sampleRequest)
        .environmentObject(AuthViewModel())
        .environmentObject(RequestViewModel())
}
