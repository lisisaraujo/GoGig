import SwiftUI

struct GoToLoginOrRegistrationSheetView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var onClose: () -> Void = {}

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .applyBackground()
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("Welcome to Care4U")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Please log in or register to continue.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        NavigationLink(destination: RegistrationView().environmentObject(authViewModel)) {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("buttonPrimary"))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }

                        NavigationLink(destination: LoginView().environmentObject(authViewModel)) {
                            Text("Login")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("buttonSecondary"))
                                .cornerRadius(10)
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
                                    .background(Color("secondaryText"))
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            })
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GoToLoginOrRegistrationSheetView()
        .environmentObject(AuthViewModel())
}
