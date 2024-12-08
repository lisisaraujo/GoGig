//
//  AddPostView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI
import CoreLocation

struct AddPostTabView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedTab: HomeTabEnum
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedType: PostTypeEnum = .offer
    @State private var isActive = true
    @State private var selectedExchangeCoins: [String] = []
    @State private var selectedCategories: [String] = []
    
    @State private var localSelectedLocation: String = ""
    @State private var localSelectedCoordinates: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationStack {
            if authViewModel.isUserLoggedIn {
                PostFormView(
                    title: $title,
                    description: $description,
                    selectedType: $selectedType,
                    isActive: $isActive,
                    selectedExchangeCoins: $selectedExchangeCoins,
                    selectedCategories: $selectedCategories,
                    selectedLocation: $localSelectedLocation,
                    selectedCoordinates: $localSelectedCoordinates,
                    isEditMode: false,
                    navigationTitle: "Add Post",
                    actionButtonText: "Create Post",
                    loadingMessage: "Adding post...",
                    onSubmit: {
                     
                            await createPost()
                    
                    }
                ).applyBackground()
            } else {
                LoginOrRegisterView(onClose: {
                    selectedTab = .search
                }).applyBackground()
                    .environmentObject(authViewModel)
            }
        }
    }
    
    private func createPost() async -> Bool {
        await postsViewModel.createPost(
            type: selectedType.rawValue,
            title: title,
            description: description,
            selectedCategories: selectedCategories,
            exchangeCoins: selectedExchangeCoins,
            isActive: isActive,
            latitude: localSelectedCoordinates?.latitude,
            longitude: localSelectedCoordinates?.longitude,
            postLocation: localSelectedLocation
        )
        
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Wait 1 second
        
        if postsViewModel.updateSuccess {
            selectedTab = .search
            dismiss() // Dismiss the AddPostTabView
            return true
        }
        
        return false
    }
}

#Preview {
    AddPostTabView(selectedTab: .constant(.add))
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}

