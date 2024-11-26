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
    @State var selectedInbox: InboxEnum = .received
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                VStack {
                    Picker("Inbox Type", selection: $selectedInbox) {
                        ForEach(InboxEnum.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type as InboxEnum?)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedInbox) { _, _ in
                        if selectedInbox == .received {
                            inboxViewModel.fetchReceivedRequests()
                        } else {
                            serviceRequestViewModel.fetchSentRequests()
                        }
                    }
                    
                    if let errorMessage = inboxViewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    List(selectedInbox == .received ? inboxViewModel.receivedRequests : serviceRequestViewModel.sentRequests) { request in
                        Button(action: {
                            navigationPath.append(request)
                        }) {
                            RequestListItemView(request: request)
                                .environmentObject(authViewModel)
                                .environmentObject(serviceRequestViewModel)
                                .frame(maxWidth: .infinity)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listStyle(.plain)
                    .refreshable {
                        inboxViewModel.fetchReceivedRequests()
                    }
                }
                .navigationTitle("Inbox")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    inboxViewModel.fetchReceivedRequests()
                }
            }
            .navigationDestination(for: ServiceRequest.self) { request in
                RequestDetailsView(request: request)
                    .environmentObject(authViewModel)
                    .environmentObject(serviceRequestViewModel)
            }
            .applyBackground()
        }
    }
}

#Preview {
    InboxTabView(selectedTab: .constant(.search))
        .environmentObject(AuthViewModel())
        .environmentObject(ServiceRequestViewModel())
        .environmentObject(InboxViewModel())
}
