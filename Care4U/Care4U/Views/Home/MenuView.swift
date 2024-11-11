//
//  MenuView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 10.11.24.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Binding var isPresented: Bool
    @Binding var shouldNavigateToEditProfile: Bool
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @State private var errorMessage: String?
    
    var body: some View {
        HStack {
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                    .shadow(color: .purple.opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    
                    Group {
                        Button(action: {
                            shouldNavigateToEditProfile = true 
                            isPresented = false
                        }) {
                            Label("Edit Profile", systemImage: "pencil.circle.fill")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            authViewModel.logout()
                            isPresented = false
                        }) {
                            Label("Logout", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            showingAlert = true
                        }) {
                            Label("Delete Account", systemImage: "trash.fill")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("Confirm Deletion"),
                                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteAccount()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        
                        .alert("Error", isPresented: Binding<Bool>(
                            get: { errorMessage != nil },
                            set: { if !$0 { errorMessage = nil } }
                        ), presenting: errorMessage) { error in
                            Button("OK") { errorMessage = nil }
                        } message: { error in
                            Text(error)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 100)
                    .frame(width: 270)
                    .background(
                        Color.white
                    )
                }
            }
            
            Spacer()
        }
        .background(.clear)
    }

    private func deleteAccount() {
        Task {
            do {
                try await authViewModel.deleteAllUserData()
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    MenuView(isPresented: .constant(true), shouldNavigateToEditProfile: .constant(true))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
