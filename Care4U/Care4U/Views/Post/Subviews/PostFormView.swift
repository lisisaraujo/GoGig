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
    @Environment(\.dismiss) private var dismiss
    
    @Binding var title: String
    @Binding var description: String
    @Binding var selectedType: PostTypeEnum
    @Binding var isActive: Bool
    @Binding var selectedExchangeCoins: [ExchangeCoinEnum]
    @Binding var selectedCategories: [CategoriesEnum]
    
    @State private var showExchangeCoins: Bool = true
    @State private var showCategories: Bool = true
    @State private var isAutocompletePresented = false
    @State private var isLoading = false
    
    let isEditMode: Bool
    let navigationTitle: String
    let actionButtonText: String
    let loadingMessage: String
    let onSubmit: () async -> Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                    Form {
                        Section(header: Text("Post Details")) {
                            CustomTextFieldView(placeholder: "Title", text: $title)
                            CustomTextEditorView(placeholder: "Description", text: $description)
                            Picker("Type", selection: $selectedType) {
                                ForEach(PostTypeEnum.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            Toggle("Is Active", isOn: $isActive)
                        }
                        
                        Section(header: HStack {
                            Text("Exchange Coins")
                            Spacer()
                            Image(systemName: showExchangeCoins ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                        }.onTapGesture {
                            withAnimation {
                                showExchangeCoins.toggle()
                            }
                        }) {
                            if showExchangeCoins {
                                ForEach(ExchangeCoinEnum.allCases, id: \.self) { coin in
                                    MultipleSelectionRow(title: coin.rawValue, isSelected: selectedExchangeCoins.contains(coin)) {
                                        if selectedExchangeCoins.contains(coin) {
                                            selectedExchangeCoins.removeAll { $0 == coin }
                                        } else {
                                            selectedExchangeCoins.append(coin)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Section(header: HStack {
                            Text("Categories")
                            Spacer()
                            Image(systemName: showCategories ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                        }.onTapGesture {
                            withAnimation {
                                showCategories.toggle()
                            }
                        }) {
                            if showCategories {
                                ForEach(CategoriesEnum.allCases, id: \.self) { category in
                                    MultipleSelectionRow(title: category.rawValue, isSelected: selectedCategories.contains(category)) {
                                        if selectedCategories.contains(category) {
                                            selectedCategories.removeAll { $0 == category }
                                        } else {
                                            selectedCategories.append(category)
                                        }
                                    }
                                }
                            }
                        }
                        
                        SelectLocationView(isAutocompletePresented: $isAutocompletePresented)
                        
                        Button(action: {
                            submitForm()
                        }) {
                            Text(actionButtonText)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(isLoading)
                    }
                
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            
            if isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    
                    Text(loadingMessage)
                        .foregroundColor(.white)
                        .padding(.top)
                }
                .frame(width: 200, height: 200)
                .background(Color.gray.opacity(0.7))
                .cornerRadius(20)
            }
        }   .onAppear {
            if !isEditMode {
                clearFields()
            }
        }
    }
    
    private func submitForm() {
        isLoading = true
        Task {
            let success = await onSubmit()
            isLoading = false
            if success {
                dismiss()
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
        postsViewModel.selectedLocation = ""
        postsViewModel.selectedCoordinates = nil
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
