import SwiftUI

struct InitialRegistrationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showValidationErrors = false
    @State private var emailSent = false
    @State private var navigateToRegistration = false

    // ✅ Live password strength tracking
    @State private var passwordStrength: PasswordStrength = .weak
    @State private var showPasswordRequirements = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear.ignoresSafeArea().applyBackground()

                VStack(spacing: 20) {
                    Text("Create Your Account")
                        .font(.largeTitle)
                        .bold()

                    // ✅ Email Field
                    CustomTextFieldView(placeholder: "Email", text: $email, isRequired: true, showError: $showValidationErrors)

                    // ✅ Password Field with Strength Indicator
                    VStack(alignment: .leading, spacing: 5) {
                        CustomSecureFieldView(
                            placeholder: "Password",
                            text: $password,
                            isRequired: true,
                            showError: $showValidationErrors
                        )
                        .onChange(of: password) { newValue,_ in
                            passwordStrength = authViewModel.evaluatePasswordStrength(newValue)
                        }

                        // ✅ Live Password Strength Indicator
                        HStack {
                            Text("Strength: \(passwordStrength.rawValue)")
                                .font(.footnote)
                                .foregroundColor(passwordStrength.color)
                            Spacer()
                            Button(action: { showPasswordRequirements.toggle() }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    // ✅ Password Requirements (Expandable)
                    if showPasswordRequirements {
                        VStack(alignment: .leading, spacing: 5) {
                            RequirementView(text: "At least 8 characters", isMet: password.count >= 8)
                            RequirementView(text: "One uppercase letter (A-Z)", isMet: authViewModel.containsUppercase(password))
                            RequirementView(text: "One number (0-9)", isMet: authViewModel.containsNumber(password))
                            RequirementView(text: "One special character (!@#$%^&*)", isMet: authViewModel.containsSpecialCharacter(password))
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }

                    // ✅ Register Button
                    Button(action: {
                        showValidationErrors = true
                        if isFormValid {
                            registerUser()
                        }
                    }) {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .disabled(!isFormValid)

                    // ✅ Email Verification Message
                    if emailSent {
                        Text("A verification email has been sent. Please verify your email before proceeding.")
                            .foregroundColor(.green)
                            .padding()

                        Button("I have verified my email") {
                            checkVerificationStatus()
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }

                    // ✅ Navigation to RegistrationView
                    NavigationLink(
                        destination: RegistrationView().environmentObject(authViewModel),
                        isActive: $navigateToRegistration
                    ) {
                        EmptyView()
                    }
                }
                .padding()
                .alert(isPresented: $authViewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text(authViewModel.alertMessage), dismissButton: .default(Text("OK")))
                }

                // ✅ Loading Indicator
                if isLoading {
                    ProgressView("Registering...")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .onAppear {
                startVerificationCheck()
            }
        }
    }

    private func registerUser() {
        isLoading = true
        authViewModel.registerEmailPassword(email: email, password: password) { success in
            isLoading = false
            if success {
                emailSent = true
            }
        }
    }

    private func checkVerificationStatus() {
        authViewModel.checkEmailVerification { verified in
            DispatchQueue.main.async {
                if verified {
                    navigateToRegistration = true
                }
            }
        }
    }

    private func startVerificationCheck() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            authViewModel.checkEmailVerification { verified in
                DispatchQueue.main.async {
                    if verified {
                        timer.invalidate()
                        navigateToRegistration = true
                    }
                }
            }
        }
    }

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && passwordStrength != .weak
    }
}
