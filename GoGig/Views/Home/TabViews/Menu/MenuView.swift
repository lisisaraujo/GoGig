//
//  MenuView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 10.11.24.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var requestViewModel: RequestViewModel
    @Binding var isPresented: Bool
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Section {
                    Button(action: {
                        isPresented = false
                        navigationPath.append("EditProfile")
                    }) {
                        Label("Edit Profile", systemImage: "person.crop.circle")
                    }.foregroundColor(.buttonSecondary)

                    Button(action: {
                        requestViewModel.pendingRequests = []
                        authViewModel.logout()
                        isPresented = false
                    }) {
                        Label("Logout", systemImage: "arrow.right.square")
                    }.foregroundColor(.buttonSecondary)
                }
                .listRowBackground(Color.surfaceBackground)

                Section {
                        NavigationLink(destination: DeleteAccountView()) {
                            Label("Delete My Account", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                
                }
                .listRowBackground(Color.surfaceBackground)
            }.background()
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .listStyle(InsetGroupedListStyle())
        }
    }
}


#Preview {
    MenuView(isPresented: .constant(true), navigationPath: .constant(NavigationPath()))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
