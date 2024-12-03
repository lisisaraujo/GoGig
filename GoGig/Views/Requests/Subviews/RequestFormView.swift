//
//  RequestFormView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import SwiftUI

struct RequestFormView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showValidationErrors = false

    let post: Post
    let creatorUser: User
    @Binding var requestMessage: String
    @Binding var contactInfo: String
    let onSubmit: () async -> Void
    
    var body: some View {
        if authViewModel.isUserLoggedIn {
            Form {
                Section(header: Text("Request Details")) {
                    CustomTextEditorView(placeholder: "Message", text: $requestMessage, isRequired: true, errorMessage: "Message is required", showError: $showValidationErrors)
                    
                    CustomTextFieldView(placeholder: "Contact Info (Phone or Email)", text: $contactInfo, isRequired: true, errorMessage: "Contact info is required", showError: $showValidationErrors)
                }
                
                Section {
                    Button("Send Request") {
                        showValidationErrors = true
                        if isFormValid {
                            Task {
                                await onSubmit()
                            }
                        }
                    }
                }
            }
            .onAppear {
                clearFields()
            }
            .navigationTitle("Send Request")
        } else {
            GoToLoginOrRegistrationSheetView(onClose: {
                dismiss()
            })
        }
    }
    
    private func clearFields() {
        requestMessage = ""
        contactInfo = ""
        showValidationErrors = false
    }
    
    private var isFormValid: Bool {
        !requestMessage.isEmpty && !contactInfo.isEmpty
    }

}

