import Foundation
import FirebaseAuth
import FirebaseStorage
import PhotosUI

class AuthViewModel: ObservableObject {
    
    private let firebaseManager = FirebaseManager.shared
    
    @Published var user: User?
    @Published var loadingState: LoadingStateEnum = .idle
    
    @Published var showLoginOrRegistrationSheet = true
    
    var isUserLoggedIn: Bool {
        return user != nil
    }
    
    init() {
        Task {
            await checkAuth()
        }
    }
    
    private func checkAuth() async {
        guard let currentUser = firebaseManager.auth.currentUser else {
            self.showLoginOrRegistrationSheet = true
            print("Not logged in")
            return
        }
        self.showLoginOrRegistrationSheet = false
        await fetchUser(with: currentUser.uid)
    }
    
    private func fetchUser(with id: String) async {
        do {
            let document = try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(id).getDocument()
            
            guard document.exists else {
                print("No such document!")
                self.user = nil
                return
            }
            
            let fetchedUser = try document.data(as: User.self)
            self.user = fetchedUser
        } catch {
            print("Error fetching user:", error)
            self.user = nil
        }
    }
    
    func logout() {
        do {
            try firebaseManager.auth.signOut()
            self.user = nil
            self.showLoginOrRegistrationSheet = true
            print("User is logged out")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func register(email: String, password: String, fullName: String, birthDate: Date, location: String, profileImage: UIImage?) {
        loadingState = .loading
        
        Task {
            do {
                let authResult = try await firebaseManager.auth.createUser(withEmail: email, password: password)
                let userID = authResult.user.uid
                print("User with email '\(email)' is registered with id '\(userID)'")
                
                var profilePicUrl: String? = nil
                if let image = profileImage {
                    profilePicUrl = await uploadProfilePicture(image, for: userID)
                }
                
                await createUser(withId: userID, email: email, fullName: fullName, birthDate: birthDate, location: location, profilePicUrl: profilePicUrl)
                loadingState = .loaded
                await checkAuth()
            } catch {
                print("Registration failed:", error.localizedDescription)
                loadingState = .error(error)
            }
        }
    }
    
    private func createUser(withId id: String, email: String, fullName: String, birthDate: Date, location: String, profilePicUrl: String?) async {
        let user = User(id: id, email: email, fullName: fullName, birthDate: birthDate, location: location, memberSince: Date(), profilePicURL: profilePicUrl)
        
        do {
            try firebaseManager.database.collection(firebaseManager.usersCollectionName).document(id).setData(from: user)
        } catch {
            print("Saving user failed:", error)
        }
    }
    
    private func uploadProfilePicture(_ image: UIImage, for userID: String) async -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to data")
            return nil
        }
        
        let storageRef = Storage.storage().reference().child("profile_pictures/\(userID).jpg")
        
        do {
            _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("Error uploading image or getting download URL:", error)
            return nil
        }
    }
    
    func login(email: String, password: String) {
        firebaseManager.auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login failed: ", error)
                return
            }
            
            guard let authResult else { return }
            self.showLoginOrRegistrationSheet = false
            print("User with email '\(authResult.user.email ?? "")' is logged in with id ‘\(authResult.user.uid)'")
            Task {
                await self.fetchUser(with: authResult.user.uid)
            }
        }
    }
    
    func anonymousLogin() {
        if !isUserLoggedIn {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print("Anonymous login failed: ", error)
                    return
                }
                
                guard let authResult else { return }
                self.showLoginOrRegistrationSheet = false
                print("Anonymous user logged in with id ‘\(authResult.user.uid)'")
                Task {
                    await self.fetchUser(with: authResult.user.uid)
                }
            }
        }
    }
    
    func onTabChanged(tab: HomeTabEnum) {
        if tab == .search {
            showLoginOrRegistrationSheet = false
        } else {
            showLoginOrRegistrationSheet = !isUserLoggedIn
        }
    }
    
    func checkSheetState(){
        showLoginOrRegistrationSheet = !isUserLoggedIn
    }
}
