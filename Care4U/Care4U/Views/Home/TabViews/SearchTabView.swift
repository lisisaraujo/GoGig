//
//  SearchTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct SearchTabView: View {
    
    @State private var searchText = ""
    @State private var postsList: [Post] = []
    @State private var errorMessage: String?
    @State private var selectedPostId: String?
    
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {

            VStack {
          
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) { oldValue, newValue in
                        Task {
                            await postsViewModel.listenToAllPosts()
                        }
                    }
              
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                
                List(postsViewModel.allPosts) { post in
                    NavigationLink(destination: PostDetailsView(postId: post.id!)
                            .environmentObject(postsViewModel)
                            .environmentObject(authViewModel)) {
                            PostItemView(post: post) 
                        }
                    }
          
            }
        }
    }


#Preview {
    SearchTabView()
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
