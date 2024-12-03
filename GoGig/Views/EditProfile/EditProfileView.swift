//
//  EditProfileView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 10.11.24.
//

import SwiftUI
import CoreLocation
import GooglePlaces

struct EditProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var birthday = Date()
    @State private var selectedImage: UIImage? = nil
    @State private var description = ""
    @State private var isImagePickerPresented = false
    @State private var isAutocompletePresented = false
    
    @State private var localSelectedLocation: String = ""
    @State private var localSelectedCoordinates: CLLocationCoordinate2D?
    
    @State private var showValidationErrors = false

    var body: some View {
        VStack(spacing: 20) {
            Form {
                Section(header: Text("Profile Picture")) {
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        HStack {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                            Text("Change Profile Picture")
                        }
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePickerView(selectedImage: $selectedImage)
                    }
                }
                .listRowBackground(Color.buttonPrimary.opacity(0.2))
                
                Section(header: Text("Personal Information")) {
                    CustomTextFieldView(placeholder: "Full Name", text: $fullName, isRequired: true, errorMessage: "Required", showError: $showValidationErrors)
                }
                .listRowBackground(Color.buttonPrimary.opacity(0.2))

                Section(header: Text("About Me")) {
                    CustomTextEditorView(placeholder: "Description", text: $description, isRequired: true, errorMessage: "Required", showError: $showValidationErrors)
                }
                .listRowBackground(Color.buttonPrimary.opacity(0.2))

                Section(header: Text("Location")) {
                    SelectLocationView(
                        selectedLocation: $localSelectedLocation,
                        selectedCoordinates: $localSelectedCoordinates,
                        isAutocompletePresented: $isAutocompletePresented
                    )
                    .environmentObject(authViewModel)
                }
                .listRowBackground(Color.buttonPrimary.opacity(0.2))
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(trailing: Button("Save") {
                saveChanges()
            })
            .scrollContentBackground(.hidden)
            .applyBackground()
        }
        .onAppear {
            loadUserData()
        }
    }
    
    private func loadUserData() {
        if let user = authViewModel.currentUser {
            fullName = user.fullName
            description = user.description ?? ""
            localSelectedLocation = user.location
            localSelectedCoordinates = CLLocationCoordinate2D(latitude: user.latitude!, longitude: user.longitude!)
        }
    }
    
    private func saveChanges() {
        Task {
            authViewModel.updateUserData(
                fullName: fullName,
                location: localSelectedLocation,
                description: description,
                latitude: localSelectedCoordinates?.latitude,
                longitude: localSelectedCoordinates?.longitude,
                profileImage: selectedImage
            ) { success in
                DispatchQueue.main.async {
                    if success {
                        dismiss()
                    } else {
                        print("Update failed")
                    }
                }
            }
        }
        authViewModel.userLocation = localSelectedLocation
        authViewModel.userLocationCoordinates = localSelectedCoordinates
    }
}

#Preview {
    EditProfileView()
        .environmentObject(AuthViewModel())
}
        
