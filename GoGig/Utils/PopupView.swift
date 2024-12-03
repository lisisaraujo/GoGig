//
//  popupView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 30.10.24.
//

//import SwiftUI
//
//struct PopupView: View {
//    
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @Binding var showLoginOrRegistrationPopup: Bool
//    
//    var body: some View {
//            GoToLoginOrRegistrationPopupView(isPresented: $showLoginOrRegistrationPopup)
//                .environmentObject(authViewModel)
//                .frame(width: 300)
//                .cornerRadius(16)
//                .shadow(radius: 10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
//                )
//    }
//}
//
//#Preview {
//    PopupView(showLoginOrRegistrationPopup: .constant(true))
//        .environmentObject(AuthViewModel())
//}
