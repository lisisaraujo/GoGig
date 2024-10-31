//
//  RegisterView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct RegistrationView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var location = ""
    @State private var birthday = Date()
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false

    
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
                            Text("Upload Profile Picture")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth:.infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                }
                .sheet(isPresented:$isImagePickerPresented) {
                    ImagePickerView(selectedImage:$selectedImage)
                }

                Group {
                    CustomTextFieldView(placeholder:"Full Name", text:$fullName)
                    CustomTextFieldView(placeholder:"Email", text:$email)
                    CustomSecureFieldView(placeholder:"Password", text:$password)
                    CustomTextFieldView(placeholder:"Location", text:$location)

                    DatePicker("Birthday", selection:$birthday, displayedComponents:.date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                 }

                 Button(action:{
                     authViewModel.register(email: email, password: password, fullName: fullName, birthDate: birthday, location: location, profileImage: selectedImage)
                 }) {
                     Text("Create Account")
                         .foregroundColor(.white)
                         .padding()
                         .frame(maxWidth:.infinity)
                         .background(Color.blue)
                         .cornerRadius(10)
                 }

                 Spacer()
                 
                ZStack {
                    HStack{
                        Spacer()
                        LoadingSpinnerView(loadingState:$authViewModel.loadingState)
                        Spacer()
                    }
                }
                

             }
             .padding()
             .navigationTitle("Registration")
             .navigationBarTitleDisplayMode(.inline)

         }

        }
     }

#Preview {
     RegistrationView()
     .environmentObject(AuthViewModel())
}
