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

    var body: some View {
        VStack {
            Text("Care4U")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                Button(action: {
                    authViewModel.login(email: email, password: password)
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
                .padding(.horizontal)
            }
            
            NavigationLink(destination: RegistrationView().environmentObject(authViewModel)) {
                Text("Don't have an account? Register")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
    
        }
    }


#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
