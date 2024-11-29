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

    var body: some View {
        VStack{
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
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else if let profilePicURL = authViewModel.currentUser?.profilePicURL,
                                      let url = URL(string: profilePicURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                            }
                            Text("Change Profile Picture")
                        }
                    }
                }
                
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $fullName)
                }
                
                Section(header: Text("About Me")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("Location")) {
                    SelectLocationView(
                        selectedLocation: $localSelectedLocation,
                        selectedCoordinates: $localSelectedCoordinates,
                        isAutocompletePresented: $isAutocompletePresented
                    )
                        .environmentObject(authViewModel)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(trailing: Button("Save") {
                saveChanges()
            })
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePickerView(selectedImage: $selectedImage)
            }
        }.applyBackground()
        .onAppear{
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
        
