//
//  LoginView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var email = ""
    @State var password = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.clear
                .applyBackground()
                .ignoresSafeArea()
            VStack {
                Text("GoGig")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .foregroundColor(.accent)
                
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.surfaceBackground)
                        .cornerRadius(10)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.surfaceBackground)
                        .cornerRadius(10)
                    
                    
                    
                    Button(action: {
                        print("logged in")
                        authViewModel.login(email: email, password: password)
                        dismiss()
                    }) {
                        Text("Login")
                            .foregroundColor(.textPrimary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.buttonPrimary)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                    .padding(.horizontal)
                }
                
            }
            
        }
    }
}


#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
