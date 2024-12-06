//
//  EditPostView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 11.11.24.
//

import SwiftUI
import CoreLocation

struct EditPostView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    let post: Post

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedType: PostTypeEnum = .offer
    @State private var isActive: Bool = true
    @State private var selectedExchangeCoins: [ExchangeCoinEnum] = []
    @State private var selectedCategories: [CategoriesEnum] = []
    @State private var localSelectedLocation: String = ""
    @State private var localSelectedCoordinates: CLLocationCoordinate2D?

    var body: some View {
        VStack{
            PostFormView(
                title: $title,
                description: $description,
                selectedType: $selectedType,
                isActive: $isActive,
                selectedExchangeCoins: $selectedExchangeCoins,
                selectedCategories: $selectedCategories,
                selectedLocation: $localSelectedLocation,
                selectedCoordinates: $localSelectedCoordinates,
                isEditMode: true,
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
        }.applyBackground()
    }

    private func loadPostData() {
        title = post.title
        description = post.description
        selectedType = PostTypeEnum(rawValue: post.type) ?? .offer
        isActive = post.isActive
        selectedExchangeCoins = post.exchangeCoins.compactMap { ExchangeCoinEnum(rawValue: $0) }
        selectedCategories = post.categories.compactMap { CategoriesEnum(rawValue: $0) }
        localSelectedLocation = post.postLocation
        localSelectedCoordinates = CLLocationCoordinate2D(latitude: post.latitude!, longitude:post.latitude!)
    }

    private func updatePost() async -> Bool {
        await postsViewModel.updatePost(
            type: selectedType.rawValue,
            title: title,
            description: description,
            isActive: isActive,
            exchangeCoins: selectedExchangeCoins.map { $0.rawValue },
            categories: selectedCategories.map { $0.rawValue },
            latitude: localSelectedCoordinates?.latitude,
            longitude: localSelectedCoordinates?.longitude,
            postLocation: localSelectedLocation
        )
        
        return postsViewModel.updateSuccess
    }

}

#Preview {
    EditPostView(
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

