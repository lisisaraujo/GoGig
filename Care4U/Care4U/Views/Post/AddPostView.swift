//
//  AddPostView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI
import CoreLocation

struct AddPostView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Binding var selectedTab: HomeTabEnum
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedType: PostTypeEnum = .offer
    @State private var isActive = true
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
            navigationTitle: "Add Post",
            actionButtonText: "Create Post",
            loadingMessage: "Adding post...",
            onSubmit: {
                await createPost()
            }
        )
    }
    
    private func createPost() async -> Bool {
        postsViewModel.createPost(
            type: selectedType.rawValue,
            title: title,
            description: description,
            selectedCategories: selectedCategories,
            exchangeCoins: selectedExchangeCoins.map { $0.rawValue },
            isActive: isActive,
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
    AddPostView(selectedTab: .constant(.search))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
