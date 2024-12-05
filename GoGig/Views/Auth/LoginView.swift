//
//  LoginView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var inboxViewModel: InboxViewModel
    
    @State var email = ""
    @State var password = ""
    
    @State private var showValidationErrors = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.clear
                .applyBackground()
                .ignoresSafeArea()
            VStack {
                Text("GoGig")
                    .font(Font.custom("Genesys", size: 32, relativeTo: .title))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .foregroundColor(.accent)
                
                VStack(spacing: 16) {
                    CustomTextFieldView(placeholder: "Email", text: $email, isRequired: true, showError: $showValidationErrors)
                    
                    SecureField("Password", text: $password)
                        .padding(20)
                        .background(Color.textSecondary.opacity(0.1))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.accent.opacity(0.3), lineWidth: 2)
                        )
                    
                    
                    
                    Button(action: {
                        print("logging in")
                        authViewModel.login(email: email, password: password) { success in
                            if success {
                                inboxViewModel.getPendingRequests()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    dismiss()
                                }
                            }
                        }
                    }){
                        Text("Login")
                            .foregroundColor(.textPrimary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.buttonPrimary)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                    
                }
                .padding(.horizontal)
                
            }
            
        if authViewModel.showToast {
                       ToastView(message: authViewModel.toastMessage, isSuccess: authViewModel.isToastSuccess)
                           .animation(.easeInOut, value: authViewModel.showToast)
                           .transition(.move(edge: .top))
                           .onAppear {
                               DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                   authViewModel.showToast = false
                               }
                           }
                   }
               }
               .alert(isPresented: $authViewModel.showAlert) {
                   Alert(title: Text("Error"), message: Text(authViewModel.alertMessage), dismissButton: .default(Text("OK")))
               }
           }
}


#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
