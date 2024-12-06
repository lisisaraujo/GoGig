//
//  PostFormView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 12.11.24.
//

import SwiftUI
import CoreLocation

struct PostFormView: View {
    
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Binding var title: String
    @Binding var description: String
    @Binding var selectedType: PostTypeEnum
    @Binding var isActive: Bool
    @Binding var selectedExchangeCoins: [ExchangeCoinEnum]
    @Binding var selectedCategories: [CategoriesEnum]
    @Binding var selectedLocation: String
    @Binding var selectedCoordinates: CLLocationCoordinate2D?
    
    @State private var showExchangeCoins = true
    @State private var showCategories = true
    @State private var isAutocompletePresented = false
    @State private var isLoading = false
    
    @State private var showValidationErrors = false
    @State private var missingExchangeCoinsError = false
    @State private var missingCategoriesError = false
    
    let isEditMode: Bool
    let navigationTitle: String
    let actionButtonText: String
    let loadingMessage: String
    let onSubmit: () async -> Bool
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
                .applyBackground()
            
            VStack(spacing: 20) {
                Form {
                    postDetailsSection
                    exchangeCoinsSection
                    categoriesSection
                    locationSection
                    submitButtonSection
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .navigationTitle(navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
            .overlay(
                Group {
                    if isLoading {
                        LoadingOverlay(message: loadingMessage)
                    }
                }
            )
        }
        .onAppear {
            if !isEditMode {
                clearFields()
            }
        }
    }
    
    // MARK: - Sections
    private var postDetailsSection: some View {
        Section(header: Text("Post Details")) {
            CustomTextFieldView(placeholder: "Title", text: $title, isRequired: true, errorMessage: "Title is required", showError: $showValidationErrors)
            CustomTextEditorView(placeholder: "Description", text: $description, isRequired: true, errorMessage: "Description is required", showError: $showValidationErrors)
            Picker("Type", selection: $selectedType) {
                ForEach(PostTypeEnum.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.vertical)
            Toggle("Is Active", isOn: $isActive)
                .padding(.vertical)
                .tint(Color.accent)
        }
        .listRowBackground(Color.surfaceBackground)
    }
    
    private var exchangeCoinsSection: some View {
        Section(header: headerWithToggle("Exchange Coins", isExpanded: $showExchangeCoins)) {
            if showExchangeCoins {
                ForEach(ExchangeCoinEnum.allCases, id: \.self) { coin in
                    MultipleSelectionRow(title: coin.rawValue, isSelected: selectedExchangeCoins.contains(coin)) {
                        toggleSelection(for: coin, in: &selectedExchangeCoins)
                    }
                }
                if missingExchangeCoinsError {
                    Text("At least one Exchange Coin is required.")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
        }
        .listRowBackground(Color.surfaceBackground)
    }
    
    private var categoriesSection: some View {
        Section(header: headerWithToggle("Categories", isExpanded: $showCategories)) {
            if showCategories {
                ForEach(CategoriesEnum.allCases, id: \.self) { category in
                    MultipleSelectionRow(title: category.rawValue, isSelected: selectedCategories.contains(category)) {
                        toggleSelection(for: category, in: &selectedCategories)
                    }
                }
                if missingCategoriesError {
                    Text("At least one Category is required.")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
        }
        .listRowBackground(Color.surfaceBackground)
    }
    
    private var locationSection: some View {
        Section(header: Text("Location")) {
            SelectLocationView(
                selectedLocation: $selectedLocation,
                selectedCoordinates: $selectedCoordinates,
                isAutocompletePresented: $isAutocompletePresented
            )
        }
        .listRowBackground(Color.surfaceBackground)
    }
    
    private var submitButtonSection: some View {
        Section {
            ButtonPrimary(title: actionButtonText, action: submitForm)
                .padding(.top, 10)
                .disabled(isLoading)
        }
        .listRowBackground(Color.clear)
    }
    
    
    // MARK: - Helpers
    private func headerWithToggle(_ title: String, isExpanded: Binding<Bool>) -> some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                .foregroundColor(Color("accent"))
        }
        .onTapGesture {
            withAnimation {
                isExpanded.wrappedValue.toggle()
            }
        }
    }
    
    private func toggleSelection<T: Equatable>(for item: T, in array: inout [T]) {
        if array.contains(item) {
            array.removeAll { $0 == item }
        } else {
            array.append(item)
        }
    }
    
    private func submitForm() {
        showValidationErrors = true
        missingExchangeCoinsError = selectedExchangeCoins.isEmpty
        missingCategoriesError = selectedCategories.isEmpty

        if isFormValid {
            isLoading = true
            Task {
                let success = await onSubmit()
                isLoading = false
                
                if success {
                    dismiss() 
                }
            }
        }
    }


    
    private func clearFields() {
        title = ""
        description = ""
        selectedType = .offer
        isActive = true
        selectedExchangeCoins = []
        selectedCategories = []
        if let user = authViewModel.currentUser,
           let latitude = user.latitude,
           let longitude = user.longitude {
            selectedLocation = user.location
            selectedCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        showExchangeCoins = true
        showCategories = true
        showValidationErrors = false
        missingExchangeCoinsError = false
        missingCategoriesError = false
    }
    
    private var isFormValid: Bool {
        !title.isEmpty &&
        !description.isEmpty &&
        !selectedLocation.isEmpty &&
        selectedCoordinates != nil &&
        !selectedExchangeCoins.isEmpty &&
        !selectedCategories.isEmpty
    }
}


#Preview {
    PostFormView(
        title: .constant(""),
        description: .constant(""),
        selectedType: .constant(.offer),
        isActive: .constant(true),
        selectedExchangeCoins: .constant([]),
        selectedCategories: .constant([]),
        selectedLocation: .constant("Berlin"),
        selectedCoordinates: .constant(CLLocationCoordinate2D(latitude: 9.0, longitude: 0.0)),
        isEditMode: true,
        navigationTitle: "Add Post",
        actionButtonText: "Create Post",
        loadingMessage: "Adding post...",
        onSubmit: {
            // simulate an async operation
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            return true
        }
    )
    .environmentObject(AuthViewModel())
    .environmentObject(PostsViewModel())
}
