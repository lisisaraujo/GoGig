//
//  PostListView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 12.11.24.
//

import SwiftUI

struct PostsListView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    let posts: [Post]
    @Binding var text: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let text = text {
                Text(text)
                    .font(.headline)
            }
            
            ForEach(posts, id: \.id) { post in
                NavigationLink(destination: PostDetailsView(postId: post.id!)
                    .environmentObject(postsViewModel)
                    .environmentObject(authViewModel)
                ){
                    PostItemView(post: post)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)
                }
            }
        }
        .padding()
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack{
        PostsListView(posts: randomPosts, text: .constant("postview"))
            .environmentObject(PostsViewModel())
            .environmentObject(AuthViewModel())
    }
}
