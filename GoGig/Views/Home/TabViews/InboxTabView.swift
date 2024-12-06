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
                    
                    if let errorMessage = requestViewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    ZStack {
                        if (selectedInbox == .received ? requestViewModel.receivedRequests : requestViewModel.sentRequests).isEmpty {
                            VStack {
                                Spacer()
                                Text("No requests")
                                    .font(.headline)
                                    .foregroundColor(.textSecondary)
                                Spacer()
                            }
                        } else {
                            List(selectedInbox == .received ? requestViewModel.receivedRequests : requestViewModel.sentRequests) { request in
                                NavigationLink(destination: {
                                    RequestDetailsView(request: request)
                                        .environmentObject(authViewModel)
                                        .environmentObject(requestViewModel)
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
                        
                        
                        if requestViewModel.showToast {
                            ToastView(message: requestViewModel.toastMessage, isSuccess: requestViewModel.isToastSuccess)
                                .animation(.easeInOut, value: requestViewModel.showToast)
                                .transition(.move(edge: .top))
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        requestViewModel.showToast = false
                                    }
                                }
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .navigationTitle("Inbox")
                .navigationBarTitleDisplayMode(.inline)
                .applyBackground()
            } else {
                LoginOrRegisterView(onClose: {
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
}
