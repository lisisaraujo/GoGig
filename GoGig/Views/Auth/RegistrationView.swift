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
    @EnvironmentObject var requestsViewModel: RequestViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var birthday = Date()
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var description = ""
    @State private var isAutocompletePresented = false
    @State private var placeholder = "About Me"
    
    @State private var isLoading = false
    @State private var showValidationErrors = false
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
                .applyBackground()
            Form {
                Section(header: Text("Profile Picture")) {
                    Button(action: { isImagePickerPresented.toggle() }) {
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
                            Text("Upload Profile Picture")
                        }
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePickerView(selectedImage: $selectedImage)
                            .presentationCornerRadius(50)
                    }
                } .listRowBackground(Color.surfaceBackground)
                
                Section(header: Text("Personal Information")) {
                    CustomTextFieldView(placeholder: "Full Name", text: $fullName, isRequired: true, showError: $showValidationErrors)
                    CustomTextFieldView(placeholder: "Email", text: $email, isRequired: true, showError: $showValidationErrors)
                    CustomSecureFieldView(placeholder: "Password", text: $password, isRequired: true, showError: $showValidationErrors)
                    DatePicker("Birthday", selection: $birthday, displayedComponents: .date).padding(.bottom)
                } .listRowBackground(Color.surfaceBackground)
                
                Section(header: Text("About Me")) {
                    CustomTextEditorView(placeholder: "About Me", text: $description, isRequired: true, showError: $showValidationErrors)
                } .listRowBackground(Color.surfaceBackground)
                
                Section(header: Text("Location")) {
                    SelectLocationView(
                        selectedLocation: $authViewModel.userLocation,
                        selectedCoordinates: $authViewModel.userLocationCoordinates,
                        isAutocompletePresented: $isAutocompletePresented
                    )
                } .listRowBackground(Color.surfaceBackground)
                
                Section {
                    Button("Register") {
                        showValidationErrors = true
                        if isFormValid {
                            registerUser()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                } .listRowBackground(Color.surfaceBackground)
            }
            .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            .navigationTitle("Registration")
            .alert(isPresented: $authViewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(authViewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .overlay(
                Group {
                    if isLoading {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                            Text("Registering...")
                                .foregroundColor(.white)
                                .padding(.top)
                        }
                        .frame(width: 200, height: 200)
                        .background(Color.gray.opacity(0.7))
                        .cornerRadius(20)
                    }
                }
            )
        }
    }
    
    private func registerUser() {
        isLoading = true
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
            isLoading = false
            if success {
                requestsViewModel.setupListeners()
                dismiss()
            }
        }
    }
    
    private var isFormValid: Bool {
        !fullName.isEmpty && !email.isEmpty && !password.isEmpty && !description.isEmpty && selectedImage != nil
    }
}

#Preview {
    RegistrationView()
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
        .environmentObject(RequestViewModel())
}
