//
//  MyProfileView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct MyProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLoginOrRegistrationSheet = false
    
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    if authViewModel.isUserLoggedIn {
                        Text("Hello, \(authViewModel.user?.fullName ?? "User")!")
                            .font(.largeTitle)
                            .padding()
                    } else {
                        GoToLoginOrRegistrationSheetView(isPresented: $showLoginOrRegistrationSheet)
                    }
                }
                .onAppear {
                    if !authViewModel.isUserLoggedIn {
                        showLoginOrRegistrationSheet = true
                    }
                }
                .navigationTitle("My Profile")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
}

#Preview {
    MyProfileView()
        .environmentObject(AuthViewModel())
}
