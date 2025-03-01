//
//  PasswordInputView.swift
//  GoGig 
//
//  Created by Lisis Ruschel on 01.03.25.
//

import SwiftUI

struct PasswordInputView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var password: String
    @State private var passwordStrength: PasswordStrength = .weak
    @State private var showRequirements = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SecureField("Password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .onChange(of: password) { newValue in
                    passwordStrength = authViewModel.evaluatePasswordStrength(newValue)
                }

            // ✅ Password Strength Bar (Fixed layout issue)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.3)) // Background bar
                    .frame(height: 6)

                Capsule()
                    .fill(passwordStrength.color)
                    .frame(width: strengthBarWidth(), height: 6)
                    .animation(.easeInOut(duration: 0.3), value: passwordStrength)
            }
            .frame(maxWidth: .infinity, minHeight: 6) // Ensures it doesn't collapse

            // ✅ Strength Label
            Text("Strength: \(passwordStrength.rawValue)")
                .font(.footnote)
                .foregroundColor(passwordStrength.color)

            // ✅ Password Requirements (Expandable)
            if showRequirements {
                VStack(alignment: .leading, spacing: 3) {
                    RequirementView(text: "At least 8 characters", isMet: password.count >= 8)
                    RequirementView(text: "One uppercase letter (A-Z)", isMet: authViewModel.containsUppercase(password))
                    RequirementView(text: "One number (0-9)", isMet: authViewModel.containsNumber(password))
                    RequirementView(text: "One special character (!@#$%^&*)", isMet: authViewModel.containsSpecialCharacter(password))
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }

            Button(action: { showRequirements.toggle() }) {
                HStack {
                    Image(systemName: "info.circle")
                    Text(showRequirements ? "Hide requirements" : "Show requirements")
                        .font(.footnote)
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 5)
        }
    }

    private func strengthBarWidth() -> CGFloat {
        switch passwordStrength {
        case .weak: return UIScreen.main.bounds.width * 0.25
        case .medium: return UIScreen.main.bounds.width * 0.5
        case .strong: return UIScreen.main.bounds.width * 0.9
        }
    }
}


#Preview {
    PasswordInputView(password: .constant("StrongPassword1!"))
}
