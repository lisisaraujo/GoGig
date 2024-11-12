//
//  InboxTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct InboxTabView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedTab: HomeTabEnum

    var body: some View {

            ScrollView {
                VStack(spacing: 20) {
                    if let user = authViewModel.currentUser {
                        Text("Hello, \(user.fullName)!")
                            .font(.largeTitle)
                            .padding()
                        
                        Button(action: {
                            authViewModel.logout()
                        }) {
                            Text("Sign Out")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth:.infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                        }
                        .padding(.horizontal)
                    } else {
                        GoToLoginOrRegistrationSheetView(onClose: {
                                                    selectedTab = .search
                                                })
                                                .environmentObject(authViewModel)
                    }
                }
         
                .navigationTitle("Inbox")
                .navigationBarTitleDisplayMode(.inline)
            }
//            .sheet(isPresented: $authViewModel.showLoginOrRegistrationSheet) {
//                GoToLoginOrRegistrationSheetView() {
//                    selectedTab = .search
//                }
//                .environmentObject(authViewModel)
//            }
        }
    }


#Preview {
    InboxTabView(selectedTab: .constant(.search))
        .environmentObject(AuthViewModel())
}
