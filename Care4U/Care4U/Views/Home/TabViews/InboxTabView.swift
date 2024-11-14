//
//  InboxTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct InboxTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var serviceRequestViewModel: ServiceRequestViewModel
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @Binding var selectedTab: HomeTabEnum

    var body: some View {
        NavigationView {
            Group {
                if authViewModel.isUserLoggedIn {
                    VStack {
                        if let errorMessage = inboxViewModel.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        List {
                            ForEach(inboxViewModel.receivedRequests) { request in
                                NavigationLink(destination: RequestDetailsView(request: request)) {
                                    RequestListItemView(request: request)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            inboxViewModel.fetchReceivedRequests()
                        }
                    }
                    .navigationTitle("Inbox")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        inboxViewModel.fetchReceivedRequests()
                    }
                } else {
                    GoToLoginOrRegistrationSheetView(onClose: {
                        selectedTab = .search 
                    })
                    .environmentObject(authViewModel)
                }
            }
        }
    }
}

struct RequestListItemView: View {
    let request: ServiceRequest

    var body: some View {
        VStack(alignment: .leading) {
            Text("From: \(request.senderUserId)")
                .font(.headline)
            Text("Status: \(request.status.rawValue)")
                .font(.subheadline)
        }
    }
}

#Preview {
    InboxTabView(selectedTab: .constant(.search))
        .environmentObject(AuthViewModel())
        .environmentObject(ServiceRequestViewModel())
        .environmentObject(InboxViewModel())
}
