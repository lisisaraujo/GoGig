//
//  UserDetailsView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct UserDetailsView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    
    var userId: String
    
    var body: some View {
        VStack{
            
   
     
        }
    }
}

#Preview {
    UserDetailsView(userId: "")
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
