//
//  PostDetailsView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct PostDetailsView: View {
    
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    var postId: String
    
    var body: some View {
        VStack {
            if let post = postsViewModel.selectedPost {
                Text(post.title)
                    .font(.largeTitle)
                    .padding()
                
                Text(post.description)
                    .padding()
                
              
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            Task {
                await postsViewModel.getSelectedPost(with: postId)
            }
        }
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PostDetailsView(postId: "sample-post-id")
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
