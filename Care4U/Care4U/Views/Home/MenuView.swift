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
        VStack(alignment: .leading) {
            Button(action: {
                isPresented = false
                shouldNavigateToEditProfile = true
            }) {
                Text("Edit Profile")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            
            Button(action: {
                authViewModel.logout()
                isPresented = false
            }) {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
            }

            Button("Delete My Account") {
                showingAlert = true
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)

            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.6)
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .onTapGesture {
            isPresented = false
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
    MenuView(isPresented: .constant(true), shouldNavigateToEditProfile: .constant(false))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
