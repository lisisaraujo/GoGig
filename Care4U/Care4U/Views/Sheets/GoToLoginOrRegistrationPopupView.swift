import SwiftUI

struct GoToLoginOrRegistrationSheetView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
   // var onCancel: () -> Void

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Please log in or register to continue.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 16) {
                    NavigationLink(destination: RegistrationView().environmentObject(authViewModel)) {
                        Text("Register")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: LoginView().environmentObject(authViewModel)) {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    
                    //onCancel()

                }) {
                    Text("Close")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal)
        }.interactiveDismissDisabled()
    }
}

#Preview {
    GoToLoginOrRegistrationSheetView()
        .environmentObject(AuthViewModel())
}
