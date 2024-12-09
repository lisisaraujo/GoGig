//
//  DeleteAccountView.swift
//  GoGig 
//
//  Created by Lisis Ruschel on 06.12.24.
//

import SwiftUI

struct DeleteAccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    @State private var password: String = ""
    @State private var isLoading = false
    @State private var showErrors = false
    @State private var errorMessage: String?
    @State private var showSuccessToast = false
    @State private var showErrorToast = false

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
                .applyBackground()
            
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
                            dismiss()
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
            .navigationTitle("Delete Account")
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
    DeleteAccountView()
        .environmentObject(AuthViewModel())
}


