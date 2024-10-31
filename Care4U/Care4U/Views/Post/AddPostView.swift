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
    @State private var type: String = ""
    @State private var isActive: Bool = true
    @State private var selectedExchangeCoins: [ExchangeCoinEnum] = []
    @State private var selectedCategories: [CategoriesEnum] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Form {
                Section(header: Text("Post Details")) {
                    TextField("Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Type", text: $type)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Toggle("Is Active", isOn: $isActive)
                }
                
                Section(header: Text("Exchange Coins")) {
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
                
                Section(header: Text("Categories")) {
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
                
                Button(action: {
                    createPost()
                }) {
                    Text("Create Post")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .navigationTitle("Add Post")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func createPost() {
        postsViewModel.createPost(
            type: type,
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
        }
    }
}

#Preview {
    AddPostView()
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
