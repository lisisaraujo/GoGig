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
    @Binding var isFlipped: Bool // Binding for flipping state
    @State private var showingAlert = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            isFlipped.toggle() // Flip back to personal view
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                isPresented = false
                                shouldNavigateToEditProfile = true // Navigate to edit profile
                            }
                        }
                    }) {
                        Label("Edit Profile", systemImage: "person.crop.circle")
                    }
                    
                    Button(action: {
                        authViewModel.logout()
                        withAnimation(.easeInOut(duration: 0.8)) {
                            isFlipped.toggle() // Flip back before logout
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                isPresented = false // Dismiss menu view after logout
                            }
                        }
                    }) {
                        Label("Logout", systemImage: "arrow.right.square")
                    }
                }

                Section {
                    Button(action: { showingAlert = true }) {
                        Label("Delete My Account", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        isFlipped.toggle() // Flip back when closing menu
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isPresented = false
                        }
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.accent)
                }
            )
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) { deleteAccount() },
                secondaryButton: .cancel()
            )
        }
        .alert("Error", isPresented:
            Binding<Bool>(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            ),
            presenting: errorMessage) { error in
                Button("OK") { errorMessage = nil }
            } message: { error in
                Text(error)
            }
    }

    private func deleteAccount() {
        Task {
            do {
                try await authViewModel.deleteAllUserData()
                withAnimation(.easeInOut(duration: 0.8)) {
                    isFlipped.toggle() // Flip back after account deletion
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isPresented = false 
                    }
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    MenuView(isPresented: .constant(true), shouldNavigateToEditProfile: .constant(false), isFlipped:.constant(false))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
