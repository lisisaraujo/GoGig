//
//  SearchTabView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.
//

import SwiftUI

struct SearchTabView: View {
    
    @State private var searchText = ""
    @State private var selectedPostType: PostTypeEnum?
    @State private var errorMessage: String?
    
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Picker("Post Type", selection: $selectedPostType) {
                Text("All").tag(nil as PostTypeEnum?)
                ForEach(PostTypeEnum.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type as PostTypeEnum?)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedPostType) { _ , _ in
                postsViewModel.filterPosts(selectedPostType: selectedPostType, searchText: searchText)
            }
            
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText) {  _ , _ in
                    postsViewModel.filterPosts(selectedPostType: selectedPostType, searchText: searchText)
                }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            List(postsViewModel.filteredPosts ?? postsViewModel.allPosts) { post in
                NavigationLink(destination: PostDetailsView(postId: post.id!)
                        .environmentObject(postsViewModel)
                        .environmentObject(authViewModel)) {
                    PostItemView(post: post)
                }
            }
            
            NavigationLink(destination: AddPostView().environmentObject(postsViewModel)
                .environmentObject(authViewModel)) {
                Text("Add Post")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            }
        }
        .onAppear {
            Task {
                await postsViewModel.listenToAllPosts()
            }
        }
    }
}

#Preview {
    SearchTabView()
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
