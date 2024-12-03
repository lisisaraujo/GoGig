//
//  InboxTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct InboxTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var requestViewModel: RequestViewModel
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @Binding var selectedTab: HomeTabEnum
    @State var selectedInbox: InboxEnum = .received

    var body: some View {
        NavigationStack {
            if authViewModel.isUserLoggedIn {
                VStack {
                    Picker("Inbox Type", selection: $selectedInbox) {
                        ForEach(InboxEnum.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type as InboxEnum?)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accentColor(Color.textPrimary)
                    .background(Color.buttonPrimary.opacity(0.5))
                    .cornerRadius(50)
                    .padding(.horizontal)
                    .onChange(of: selectedInbox) { _, _ in
                        if selectedInbox == .received {
                            inboxViewModel.fetchReceivedRequests()
                        } else {
                            requestViewModel.fetchSentRequests()
                        }
                    }
                    
                    if let errorMessage = inboxViewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    ZStack {
                        if (selectedInbox == .received ? inboxViewModel.receivedRequests : requestViewModel.sentRequests).isEmpty {
                            VStack {
                                Spacer()
                                Text("No requests")
                                    .font(.headline)
                                    .foregroundColor(.textSecondary)
                                Spacer()
                            }
                        } else {
                            List(selectedInbox == .received ? inboxViewModel.receivedRequests : requestViewModel.sentRequests) { request in
                                NavigationLink(destination: {
                                    RequestDetailsView(request: request)
                                }) {
                                    RequestListItemView(request: request)
                                        .environmentObject(authViewModel)
                                        .environmentObject(requestViewModel)
                                        .frame(maxWidth: .infinity)
                                }
                                .listRowBackground(Color.clear)
                            }
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .listStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .refreshable {
                        inboxViewModel.fetchReceivedRequests()
                    }
                }
                .navigationTitle("Inbox")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    inboxViewModel.fetchReceivedRequests()
                }
                .navigationDestination(for: Request.self) { request in
                    RequestDetailsView(request: request)
                        .environmentObject(authViewModel)
                        .environmentObject(requestViewModel)
                }
                .applyBackground()
            } else {
                GoToLoginOrRegistrationSheetView(onClose: {
                    selectedTab = .search
                })
                .environmentObject(authViewModel)
            }
        }
       
    }
}

#Preview {
    InboxTabView(selectedTab: .constant(.search))
        .environmentObject(AuthViewModel())
        .environmentObject(RequestViewModel())
        .environmentObject(InboxViewModel())
}
