//
//  RegisterView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI
import CoreLocation
import GooglePlaces

struct RegistrationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var birthday = Date()
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var description = ""
    
    @State private var isAutocompletePresented = false


    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    VStack {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePickerView(selectedImage: $selectedImage)
                }
                
                CustomTextFieldView(placeholder: "Full Name", text: $fullName)
                
                CustomTextFieldView(placeholder: "Email", text: $email)
                
                CustomSecureFieldView(placeholder: "Password", text: $password)
                
                DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.horizontal)

                // About Me Text Field
                TextField("About Me", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SelectLocationView(
                    selectedLocation: $authViewModel.userLocation,
                    selectedCoordinates: $authViewModel.userLocationCoordinates,
                    isAutocompletePresented: $isAutocompletePresented
                )

                Button("Register") {
                    authViewModel.register(
                        email: email,
                        password: password,
                        fullName: fullName,
                        birthDate: birthday,
                        location: authViewModel.userLocation,
                        description: description,
                        latitude: authViewModel.userLocationCoordinates?.latitude,
                        longitude: authViewModel.userLocationCoordinates?.longitude,
                        profileImage: selectedImage
                    ) { success in
                        DispatchQueue.main.async {
                            if success {
                                dismiss()
                            } else {
                                print("Registration failed")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }.applyBackground()
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RegistrationView()
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
}
