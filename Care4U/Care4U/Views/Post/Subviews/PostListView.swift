//
//  PostListView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 12.11.24.
//

import SwiftUI

struct PostsListView: View {
    let posts: [Post]
    @Binding var selectedTab: HomeTabEnum
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Posts")
                .font(.headline)
            ForEach(posts, id: \.id) { post in
                PostItemView(selectedTab: $selectedTab, post: post)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

//#Preview {
//    PostsListView(selectedTab: .constant(.search))
//}
