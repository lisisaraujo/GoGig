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
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @Binding var isPresented: Bool
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) var dismiss

    @State private var showingDeletionSheet = false
    @State private var showErrors = false
    @State private var errorMessage: String?
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var showSuccessToast = false
    @State private var showErrorToast = false

    var body: some View {
        ZStack {
            Color.clear
                .applyBackground()

            List {
                Section {
                    Button(action: {
                        isPresented = false
                        navigationPath.append("EditProfile")
                    }) {
                        Label("Edit Profile", systemImage: "person.crop.circle")
                    }.foregroundColor(.buttonSecondary)

                    Button(action: {
                        inboxViewModel.pendingRequests = []
                        authViewModel.logout()
                        isPresented = false
                    }) {
                        Label("Logout", systemImage: "arrow.right.square")
                    }.foregroundColor(.buttonSecondary)
                }     .listRowBackground(Color.buttonPrimary.opacity(0.2))

                Section {
                    Button(action: {
                        showingDeletionSheet = true
                    }) {
                        Label("Delete My Account", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }     .listRowBackground(Color.buttonPrimary.opacity(0.2))
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .listStyle(InsetGroupedListStyle())
       
            .sheet(isPresented: $showingDeletionSheet) {
                ZStack {
                    Color.clear
                        .applyBackground()

                    accountDeletionSheet.presentationDetents([.medium])
                }
            }
            .overlay(
                VStack {
                    if showSuccessToast {
                        ToastView(message: "Account successfully deleted!", isSuccess: true)
                            .padding(.top, 50)
                    } else if showErrorToast, let errorMessage = errorMessage {
                        ToastView(message: errorMessage, isSuccess: false)
                            .padding(.top, 50)
                    }
                }
                .animation(.easeInOut, value: showSuccessToast || showErrorToast)
                .zIndex(1)
            )
        }
    }

    var accountDeletionSheet: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView("Deleting...")
                    .padding()
            } else {
                Text("Confirm Deletion")
                    .font(.headline)
                Text("Please enter your password to confirm account deletion. This action cannot be undone.")
                    .multilineTextAlignment(.center)

                CustomSecureFieldView(
                    placeholder: "Password",
                    text: $password,
                    isRequired: true,
                    errorMessage: "Password is required.",
                    showError: $showErrors
                )

                HStack {
                    Button("Cancel") {
                        showingDeletionSheet = false
                        resetState()
                    }
                    .padding()
                    .foregroundColor(.buttonSecondary)

                    Spacer()

                    Button("Delete My Account") {
                        handleDeleteButtonTapped()
                    }
                    .padding()
                    .foregroundColor(.red)
                }
            }
        }
        .padding()
    }

    private func handleDeleteButtonTapped() {
        showErrors = password.isEmpty
        if !showErrors {
            Task {
                await handleAccountDeletion()
            }
        }
    }

    private func handleAccountDeletion() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await authViewModel.reauthenticateUser(password: password)
            try await authViewModel.deleteAllUserData()

            resetState()
            showingDeletionSheet = false
            showSuccessToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSuccessToast = false
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
            showErrors = true
            showErrorToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showErrorToast = false
            }
        }
    }

    private func resetState() {
        password = ""
        errorMessage = nil
        showErrors = false
    }
}


#Preview {
    MenuView(isPresented: .constant(true), navigationPath: .constant(NavigationPath()))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
