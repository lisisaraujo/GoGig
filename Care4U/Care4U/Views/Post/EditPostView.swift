//
//  EditPostView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 11.11.24.
//

import SwiftUI

struct EditPostView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Binding var selectedTab: HomeTabEnum
    let post: Post

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedType: PostTypeEnum = .offer
    @State private var isActive: Bool = true
    @State private var selectedExchangeCoins: [ExchangeCoinEnum] = []
    @State private var selectedCategories: [CategoriesEnum] = []

    var body: some View {
        PostFormView(
            selectedTab: $selectedTab,
            title: $title,
            description: $description,
            selectedType: $selectedType,
            isActive: $isActive,
            selectedExchangeCoins: $selectedExchangeCoins,
            selectedCategories: $selectedCategories,
            navigationTitle: "Edit Post",
            actionButtonText: "Save Changes",
            loadingMessage: "Updating post...",
            onSubmit: {
                await updatePost()
            }
        )
        .onAppear {
            loadPostData()
        }
    }

    private func loadPostData() {
        title = post.title
        description = post.description
        selectedType = PostTypeEnum(rawValue: post.type) ?? .offer
        isActive = post.isActive
        selectedExchangeCoins = post.exchangeCoins.compactMap { ExchangeCoinEnum(rawValue: $0) }
        selectedCategories = post.categories.compactMap { CategoriesEnum(rawValue: $0) }
    }

    private func updatePost() async -> Bool {
        await postsViewModel.updatePost(
            type: selectedType.rawValue,
            title: title,
            description: description,
            isActive: isActive,
            exchangeCoins: selectedExchangeCoins.map { $0.rawValue },
            categories: selectedCategories.map { $0.rawValue },
            latitude: postsViewModel.selectedCoordinates?.latitude,
            longitude: postsViewModel.selectedCoordinates?.longitude,
            postLocation: postsViewModel.selectedLocation
        )
        
        // wait for a short time to allow the operation to complete
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        return postsViewModel.updateSuccess
    }
}

#Preview {
    EditPostView(
        selectedTab: .constant(.search),
        post: Post(
            id: "1",
            userId: "user1",
            type: "Offer",
            title: "Sample Post",
            description: "Description",
            isActive: true,
            exchangeCoins: ["Coin1"],
            categories: ["Category1"],
            createdOn: Date(),
            latitude: 0,
            longitude: 0,
            postLocation: "Sample Location"
        )
    )
    .environmentObject(PostsViewModel())
}

