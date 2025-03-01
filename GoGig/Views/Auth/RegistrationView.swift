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
    @State private var fullName = ""
    @State private var birthday = Date()
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var description = ""
    @State private var isAutocompletePresented = false
    @State private var isLoading = false
    @State private var showValidationErrors = false

    @State private var isVerified = false

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea().applyBackground()

            if !isVerified {
                VStack {
                    Text("Please verify your email before proceeding.")
                        .foregroundColor(.red)
                        .padding()

                    Button("Check Verification Status") {
                        checkVerificationStatus()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
            } else {
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
                    }

                    Section(header: Text("Personal Information")) {
                        CustomTextFieldView(placeholder: "Full Name", text: $fullName, isRequired: true, showError: $showValidationErrors)
                        DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                            .padding(.bottom)
                    }

                    Section(header: Text("About Me")) {
                        CustomTextEditorView(placeholder: "About Me", text: $description, isRequired: true, showError: $showValidationErrors)
                    }

                    Section {
                        Button("Complete Registration") {
                            showValidationErrors = true
                            if isFormValid {
                                completeRegistration()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                }
                .navigationTitle("Complete Registration")
                .onAppear {
                    checkVerificationStatus()
                }
            }
        }
    }

    private func checkVerificationStatus() {
        authViewModel.checkEmailVerification { verified in
            DispatchQueue.main.async {
                isVerified = verified
            }
        }
    }

    private func completeRegistration() {
        isLoading = true
        authViewModel.completeUserProfile(
            fullName: fullName,
            birthDate: birthday,
            description: description,
            profileImage: selectedImage
        ) { success in
            isLoading = false
            if success {
                authViewModel.loginUserAutomatically()
            }
        }
    }

    private var isFormValid: Bool {
        !fullName.isEmpty && !description.isEmpty && selectedImage != nil
    }
}


#Preview {
    RegistrationView()
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
        .environmentObject(RequestViewModel())
}
