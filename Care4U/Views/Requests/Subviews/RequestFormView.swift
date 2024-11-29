//
//  RequestFormView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import SwiftUI

struct RequestFormView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    let post: Post
    let creatorUser: User
    @Binding var requestMessage: String
    @Binding var contactInfo: String
    let onSubmit: () async -> Void
    
    var body: some View {
        if authViewModel.isUserLoggedIn{
            Form {
                Section(header: Text("Request Details")) {
                    CustomTextEditorView(placeholder: "Message (Optional)", text: $requestMessage)
                    CustomTextFieldView(placeholder: "Contact Info (Phone or Email)", text: $contactInfo)
                }
                
                Section {
                    Button("Send Request") {
                        Task {
                            await onSubmit()
                        }
                    }
                }
            }.onAppear{
                clearFields()
            }
            .navigationTitle("Send Request")
        }  else {
            GoToLoginOrRegistrationSheetView(onClose: {
                   dismiss() 
               })
    }
    }
    
    private func clearFields() {
        requestMessage = ""
        contactInfo = ""
    }
}

