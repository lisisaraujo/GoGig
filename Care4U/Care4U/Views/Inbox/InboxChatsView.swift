////
////  InboxChatsView.swift
////  Care4U
////
////  Created by Lisis Ruschel on 28.10.24.
////
//
//import SwiftUI
//
//struct InboxView: View {
//    @ObservedObject var inboxViewModel = InboxViewModel()
//    @StateObject var serviceRequestViewModel = ServiceRequestViewModel()
//    
//    var body: some View {
//        List(inboxViewModel.receivedRequests) { request in
//            RequestNotificationView(serviceRequestViewModel: serviceRequestViewModel, request: request)
//        }
//        .onAppear {
//            inboxViewModel.fetchReceivedRequests()
//        }
//    }
//}
//
//
//#Preview {
//    InboxView()
//        .environmentObject(AuthViewModel())
//}
