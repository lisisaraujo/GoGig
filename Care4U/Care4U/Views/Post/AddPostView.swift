//
//  AddPostView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI


struct AddPostView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Environment(\.dismiss) private var dismiss
 
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedType: PostTypeEnum = .offer
    @State private var isActive: Bool = true
    @State private var selectedExchangeCoins: [ExchangeCoinEnum] = []
    @State private var selectedCategories: [CategoriesEnum] = []
    @State private var showExchangeCoins: Bool = false
    @State private var showCategories: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // if authViewModel.isUserLoggedIn {
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

                    Button(action: createPost) {
                        Text("Create Post")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

//            } else {
//                GoToLoginOrRegistrationSheetView()
//            }
        }
        .navigationTitle("Add Post")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }

    private func createPost() {
        postsViewModel.createPost(
            type: selectedType.rawValue,
            title: title,
            description: description,
            selectedCategories: selectedCategories,
            exchangeCoins: selectedExchangeCoins.map { $0.rawValue },
            isActive: isActive
        )
        
        dismiss()
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(8)
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    AddPostView()
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
