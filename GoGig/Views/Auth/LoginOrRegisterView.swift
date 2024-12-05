import SwiftUI

struct LoginOrRegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var onClose: () -> Void = {}

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .background()
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("GoGig")
                        .font(.custom("Genesys", size: 64))
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                        .foregroundColor(.accent)
                    
                    Text("Please log in or register to continue.")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        
                        NavigationLink(destination: LoginView().environmentObject(authViewModel)) {
                            Text("Login")
                                .foregroundColor(.textPrimary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.accent.opacity(0.9))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                        
                        NavigationLink(destination: RegistrationView().environmentObject(authViewModel)) {
                            Text("Register")
                                .foregroundColor(.textPrimary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.buttonPrimary.opacity(0.7))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationBarItems(trailing: Button(action: {
                onClose()
            }) {
                Image(systemName: "xmark")
                                    .foregroundColor(Color("background"))
                                    .padding(10)
                                    .background(Color.textSecondary.opacity(0.5))
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            })
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoginOrRegisterView()
        .environmentObject(AuthViewModel())
}
