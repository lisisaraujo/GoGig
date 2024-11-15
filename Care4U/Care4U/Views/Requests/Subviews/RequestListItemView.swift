//
//  RequestListItemView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 15.11.24.
//

import SwiftUI

struct RequestListItemView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var serviceRequestViewModel: ServiceRequestViewModel
    let request: ServiceRequest
    @State var userData: User?

    var body: some View {
        VStack(alignment: .leading) {
            Text("From: \(userData?.fullName ?? "Unknown")")
                .font(.headline)
            Text("Status: \(request.status.rawValue)")
                .font(.subheadline)
        }.onAppear(){
            Task{
             await userData = authViewModel.fetchUser(with: request.senderUserId)
            }
        }
    }
}

//#Preview {
//    RequestListItemView()
//}
