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
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @State private var errorMessage: String?

    var body: some View {
        List {
            Section {
                Button(action: {
                    isPresented = false
                    navigationPath.append("EditProfile")
                }) {
                    Label("Edit Profile", systemImage: "person.crop.circle")
                }
                
                Button(action: {
                    authViewModel.logout()
                    isPresented = false
                }) {
                    Label("Logout", systemImage: "arrow.right.square")
                }
            }
            
            Section {
                Button(action: {
                    showingAlert = true
                }) {
                    Label("Delete My Account", systemImage: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
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
    MenuView(isPresented: .constant(true), navigationPath: .constant(NavigationPath()))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
