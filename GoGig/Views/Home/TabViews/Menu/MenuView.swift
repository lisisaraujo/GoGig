//
//  MenuView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 10.11.24.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    //@Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: HomeTabEnum
    
    var body: some View {
        if authViewModel.isUserLoggedIn{
            List {
                Section {
                    NavigationLink(destination: EditProfileView()
                        .environmentObject(authViewModel)) {
                            MenuRow(icon: "person.crop.circle", text: "Edit Profile", color: .blue)
                        }
                    
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        MenuRow(icon: "arrow.right.square", text: "Logout", color: .blue)
                    }
                }.listRowBackground(Color.surfaceBackground)
                
                Section {
                    NavigationLink(destination: DeleteAccountView()    .environmentObject(authViewModel)) {
                        MenuRow(icon: "trash", text: "Delete Account", color: .red)
                    }
                }.listRowBackground(Color.surfaceBackground)
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            .applyBackground()
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            
        } else {
            VStack {
                LoginOrRegisterView(onClose: {
                    selectedTab = .personal
                })
            }
        }
    }
}

    struct MenuRow: View {
        let icon: String
        let text: String
        let color: Color
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 30)
                Text(text)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 8)
        }
    }
    
    #Preview {
        NavigationStack{
            MenuView(selectedTab: .constant(.search))
                .environmentObject(AuthViewModel())
                .environmentObject(PostsViewModel())
        }
    }
