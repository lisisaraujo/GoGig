
//
//  PostsViewModel.swift
//  Care4U
//
//  Created by Lisis Ruschel on 29.10.24.


import Foundation
import FirebaseAuth
import FirebaseStorage
import PhotosUI
import CoreLocation

@MainActor
class AuthViewModel: ObservableObject {
    
    private let firebaseManager = FirebaseManager.shared
    
    @Published var currentUser: User?
    @Published var selectedUser: User?
    @Published var reviewerUser: User?
    @Published var userReviews: [Review] = []
    @Published var loadingState: LoadingStateEnum = .idle
    @Published var userLocation: String = ""
    @Published var userLocationCoordinates: CLLocationCoordinate2D?
    @Published var allowNavigateToRegistration = false
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var isToastSuccess = false


    func registerEmailPassword(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    switch error.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        self.alertMessage = "This email is already registered. Try logging in instead."
                    case AuthErrorCode.invalidEmail.rawValue:
                        self.alertMessage = "Invalid email format. Please enter a valid email."
                    case AuthErrorCode.weakPassword.rawValue:
                        self.alertMessage = "Your password is too weak. Please use at least 8 characters, including an uppercase letter, a number, and a special character."
                    case 17999: // Catching internal Firebase error (often weak password)
                        self.alertMessage = "Your password does not meet security requirements. Please choose a stronger password."
                    default:
                        self.alertMessage = "Registration failed: \(error.localizedDescription)"
                    }

                    self.showAlert = true
                    print("Firebase Auth Error: \(error.localizedDescription) (Code: \(error.code))")
                }
                completion(false)
                return
            }

            // Send verification email
            result?.user.sendEmailVerification(completion: nil)
            completion(true)
        }
    }

    func evaluatePasswordStrength(_ password: String) -> PasswordStrength {
        let length = password.count >= 8
        let hasUppercase = containsUppercase(password)
        let hasNumber = containsNumber(password)
        let hasSpecialCharacter = containsSpecialCharacter(password)

        if length && hasUppercase && hasNumber && hasSpecialCharacter {
            return .strong
        } else if length && (hasUppercase || hasNumber || hasSpecialCharacter) {
            return .medium
        } else {
            return .weak
        }
    }

    func containsUppercase(_ text: String) -> Bool {
        return text.range(of: "[A-Z]", options: .regularExpression) != nil
    }

    func containsNumber(_ text: String) -> Bool {
        return text.range(of: "[0-9]", options: .regularExpression) != nil
    }

    func containsSpecialCharacter(_ text: String) -> Bool {
        return text.range(of: "[@$!%*?&]", options: .regularExpression) != nil
    }



       func checkEmailVerification(completion: @escaping (Bool) -> Void) {
           Auth.auth().currentUser?.reload { _ in
               let isVerified = Auth.auth().currentUser?.isEmailVerified ?? false
               completion(isVerified)
           }
       }

        func completeUserProfile(fullName: String, birthDate: Date, description: String, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
            guard let userID = Auth.auth().currentUser?.uid else {
                completion(false)
                return
            }

            let userData: [String: Any] = [
                "fullName": fullName,
                "birthDate": birthDate,
                "description": description
            ]

            firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userID).setData(userData, merge: true) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
        }

        func loginUserAutomatically() {
            // Redirect user to home screen or main dashboard
        }


    
    private func handleError(_ error: Error, message: String) {
        print("\(message): \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.alertMessage = "\(message): \(error.localizedDescription)"
            self.showAlert = true
        }
    }

    
    var isUserLoggedIn: Bool {
        return currentUser != nil
    }
    
    init() {
        Task {
            await checkAuth()
        }
    }
    
    @MainActor
    func addReview(_ review: Review) async {
        do {
            let _ = try firebaseManager.database.collection(firebaseManager.reviewsCollectionName).addDocument(from: review)
            updateUserRating(userId: review.userId, newRating: review.rating)
            
            self.toastMessage = "Review submitted successfully."
            Task {
                await fetchUserReviews(for: review.userId)
            }
            self.isToastSuccess = true
        } catch {
            self.toastMessage = "Failed to submit review: \(error.localizedDescription)"
            self.isToastSuccess = false
        }
        self.showToast = true
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            DispatchQueue.main.async {
                self.alertMessage = "Email and password cannot be empty."
                self.showAlert = true
            }
            completion(false)
            return
        }

        // Sign out any existing session before login
        try? Auth.auth().signOut()

        firebaseManager.auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    switch error.code {
                    case AuthErrorCode.invalidEmail.rawValue:
                        self.alertMessage = "Invalid email format. Please enter a valid email."
                    case AuthErrorCode.wrongPassword.rawValue:
                        self.alertMessage = "Incorrect password. Please try again."
                    case AuthErrorCode.userNotFound.rawValue:
                        self.alertMessage = "No account found with this email."
                    case AuthErrorCode.userDisabled.rawValue:
                        self.alertMessage = "This account has been disabled. Please contact support."
                    default:
                        self.alertMessage = "Login failed. Please check your credentials."
                    }
                    self.showAlert = true
                }
                completion(false)
                return
            }

            guard let user = authResult?.user else {
                completion(false)
                return
            }

            // Prevent unverified users from accessing the system
            if !user.isEmailVerified {
                DispatchQueue.main.async {
                    self.alertMessage = "Please verify your email before logging in."
                    self.showAlert = true
                }
                try? Auth.auth().signOut()
                completion(false)
                return
            }

            Task {
                do {
                    await self.fetchUserData(with: user.uid)
                    DispatchQueue.main.async {
                        self.showToast = true
                        self.toastMessage = "Successfully logged in"
                        self.isToastSuccess = true
                        completion(true)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.alertMessage = "Error loading user data."
                        self.showAlert = true
                    }
                    completion(false)
                }
            }
        }
    }



    
    func register(email: String, password: String, fullName: String, birthDate: Date, location: String, description: String?, latitude: Double?, longitude: Double?, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        loadingState = .loading

        Task {
            do {
                let authResult = try await firebaseManager.auth.createUser(withEmail: email, password: password)
                let userID = authResult.user.uid

                // Send email verification
                try await authResult.user.sendEmailVerification()

                var profilePicUrl: String? = nil
                if let image = profileImage {
                    profilePicUrl = await uploadProfilePicture(image, for: userID)
                }

                await createUser(withId: userID, email: email, fullName: fullName, birthDate: birthDate, location: location, description: description, latitude: latitude, longitude: longitude, profilePicUrl: profilePicUrl)

                loadingState = .loaded
                await checkAuth()

                DispatchQueue.main.async {
                    self.showToast = true
                    self.toastMessage = "Registration successful! Please verify your email."
                    self.isToastSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        completion(true)
                    }
                }
            } catch let error as NSError {
                loadingState = .error(error)

                DispatchQueue.main.async {
                    switch error.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        self.alertMessage = "This email is already registered."
                    case AuthErrorCode.invalidEmail.rawValue:
                        self.alertMessage = "Invalid email format. Please enter a valid email."
                    case AuthErrorCode.weakPassword.rawValue:
                        self.alertMessage = "Password is too weak. Please follow the password guidelines."
                    default:
                        self.alertMessage = "Registration failed. Please try again."
                    }
                    self.showAlert = true
                }
                completion(false)
            }
        }
    }



    
    
    
    func checkAuth() async {
        guard let currentUserId = firebaseManager.auth.currentUser?.uid else {
            print("Not logged in")
            self.currentUser = nil
            return
        }
        await fetchUserData(with: currentUserId)
    }
    
    func reauthenticateUser(password: String) async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        try await user.reauthenticate(with: credential)
        print("User successfully reauthenticated")
    }
    
    
    func fetchUserData(with id: String) async -> User? {
        print("Fetching user with ID: \(id)")
        do {
            let document = try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(id).getDocument()
            
            guard document.exists else {
                print("No such document!")
                resetUserData(for: id)
                return nil
            }
            
            let fetchedUser = try document.data(as: User.self)
            if id == firebaseManager.userId {
                self.currentUser = fetchedUser
            } else {
                self.selectedUser = fetchedUser
            }
            return fetchedUser
        } catch {
            print("Error fetching user:", error)
            resetUserData(for: id)
            return nil
        }
    }
    
    func fetchReviwerData(with id: String) async -> User? {
        print("Fetching user with ID: \(id)")
        do {
            let document = try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(id).getDocument()
            
            guard document.exists else {
                print("No such document!")
                resetUserData(for: id)
                return nil
            }
            
            let fetchedUser = try document.data(as: User.self)
            if id == firebaseManager.userId {
                self.currentUser = fetchedUser
            } else {
                self.reviewerUser = fetchedUser
            }
            return fetchedUser
        } catch {
            print("Error fetching user:", error)
            resetUserData(for: id)
            return nil
        }
    }
    
    func fetchUserReviews(for userId: String) async {
        print("Fetching reviews for user ID: \(userId)")
        do {
            let reviewsQuery = firebaseManager.database.collection("reviews").whereField("userId", isEqualTo: userId)
            let snapshot = try await reviewsQuery.getDocuments()
            let reviews = snapshot.documents.compactMap { try? $0.data(as: Review.self) }
            self.userReviews = reviews
        } catch {
            print("Error fetching user reviews:", error.localizedDescription)
            self.userReviews = []
        }
    }
    
    private func resetUserData(for id: String) {
        if id == currentUser?.id {
            self.currentUser = nil
        } else {
            self.selectedUser = nil
        }
    }
    
    func logout() {
        do {
            try firebaseManager.auth.signOut()
            resetAllProperties()
            print("User is logged out and all properties reset")
        } catch {
            print("Logout failed:", error.localizedDescription)
        }
    }
    
    
    
    private func createUser(withId id: String, email: String, fullName: String, birthDate: Date, location: String, description: String?, latitude: Double?, longitude: Double?, profilePicUrl: String?) async {
        let user = User(id: id, email: email, fullName: fullName, birthDate: birthDate, location: location, description: description, latitude: latitude, longitude: longitude, memberSince: Date(), profilePicURL: profilePicUrl)
        
        do {
            try firebaseManager.database.collection(firebaseManager.usersCollectionName).document(id).setData(from: user)
        } catch {
            print("Saving user failed:", error)
        }
    }
    
    func uploadProfilePicture(_ image: UIImage, for userID: String) async -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to data")
            return nil
        }
        
        let storageRef = Storage.storage().reference().child("\(firebaseManager.profilePicStorageRef)/\(userID).jpg")
        
        do {
            _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("Error uploading image or getting download URL:", error)
            return nil
        }
    }
    
    func updateUserData(fullName: String?, location: String?, description: String?, latitude: Double?, longitude: Double?, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let userId = currentUser?.id else {
            completion(false)
            return
        }
        
        loadingState = .loading
        Task {
            var updatedFields: [String: Any] = [:]
            
            // update full name if provided
            if let newFullName = fullName {
                updatedFields["fullName"] = newFullName
            }
            
            // update location and coordinates
            if let newLocation = location {
                updatedFields["location"] = newLocation
            }
            if let newLatitude = latitude {
                updatedFields["latitude"] = newLatitude
            }
            if let newLongitude = longitude {
                updatedFields["longitude"] = newLongitude
            }
            
            // update description
            if let newDescription = description {
                updatedFields["description"] = newDescription
            }
            
            // upload new profile pic
            if let newImage = profileImage {
                if let profilePicUrl = await uploadProfilePicture(newImage, for: userId) {
                    updatedFields["profilePicURL"] = profilePicUrl
                }
            }
            
            // update firestore if there are any fields to update
            if !updatedFields.isEmpty {
                do {
                    try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId).updateData(updatedFields)
                    
                    // update local user properties with changes
                    if let newFullName = updatedFields["fullName"] as? String { self.currentUser?.fullName = newFullName }
                    if let newLocation = updatedFields["location"] as? String { self.currentUser?.location = newLocation }
                    if let newLatitude = updatedFields["latitude"] as? Double { self.currentUser?.latitude = newLatitude }
                    if let newLongitude = updatedFields["longitude"] as? Double { self.currentUser?.longitude = newLongitude }
                    if let newDescription = updatedFields["description"] as? String { self.currentUser?.description = newDescription }
                    if let newProfilePicUrl = updatedFields["profilePicURL"] as? String { self.currentUser?.profilePicURL = newProfilePicUrl }
                    
                    loadingState = .loaded
                    completion(true)
                    
                } catch {
                    print("Error updating user data:", error.localizedDescription)
                    loadingState = .error(error)
                    completion(false)
                }
            } else {
                loadingState = .loaded
                completion(true)
            }
        }
    }
    
    // delete firestore user data
    private func deleteUserData(userId: String) async throws {
        do {
            try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId).delete()
            print("User Firestore data deleted successfully")
        } catch {
            print("Error deleting Firestore data: \(error.localizedDescription)")
            throw error
        }
    }
    
    // delete firestore user data
    private func deleteUserPosts(userId: String) async throws {
        do {
            // get a query of all posts that matches the users id
            let querySnapshot = try await firebaseManager.database
                .collection(firebaseManager.postsCollectionName)
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            // Loop through the results and delete each document
            for document in querySnapshot.documents {
                try await document.reference.delete()
                print("Deleted post with ID: \(document.documentID)")
            }
            
            print("All user posts deleted successfully")
            
        } catch {
            print("Error deleting user posts: \(error.localizedDescription)")
            throw error
        }
    }
    
    // delete Storage Data (profilePic)
    private func deleteStorageData(userId: String) async throws {
        let storageRef = Storage.storage().reference().child("\(firebaseManager.profilePicStorageRef)/\(userId).jpg")
        do {
            try await storageRef.delete()
            print("User profile picture deleted successfully")
        } catch {
            print("Profile picture not found or already deleted: \(error.localizedDescription)")
        }
    }
    
    // delete auth account
    private func deleteAuthAccount() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found in Firebase Auth"])
        }
        do {
            try await currentUser.delete()
            print("User authentication account deleted successfully")
        } catch {
            print("Error deleting authentication account: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func deleteUserSentRequest(userId: String) async throws {
        do {
            // get a query of all posts that matches the users id
            let querySnapshot = try await firebaseManager.database
                .collection(firebaseManager.requestsCollectionName)
                .whereField("senderUserId", isEqualTo: userId)
                .getDocuments()
            
            // Loop through the results and delete each document
            for document in querySnapshot.documents {
                try await document.reference.delete()
                print("Deleted request with ID: \(document.documentID)")
            }
            
            print("All user sent requests deleted successfully")
            
        } catch {
            print("Error deleting requests: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func deleteUserReceivedRequest(userId: String) async throws {
        do {
            // get a query of all posts that matches the users id
            let querySnapshot = try await firebaseManager.database
                .collection(firebaseManager.requestsCollectionName)
                .whereField("recipientUserId", isEqualTo: userId)
                .getDocuments()
            
            // Loop through the results and delete each document
            for document in querySnapshot.documents {
                try await document.reference.delete()
                print("Deleted request with ID: \(document.documentID)")
            }
            
            print("All user received requests deleted successfully")
            
        } catch {
            print("Error deleting requests: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func deleteUserSentReviews(userId: String) async throws {
        do {
            // get a query of all posts that matches the users id
            let querySnapshot = try await firebaseManager.database
                .collection(firebaseManager.reviewsCollectionName)
                .whereField("reviewerId", isEqualTo: userId)
                .getDocuments()
            
            // Loop through the results and delete each document
            for document in querySnapshot.documents {
                try await document.reference.delete()
                print("Deleted reviews with ID: \(document.documentID)")
            }
            
            print("All user sent reviews deleted successfully")
            
        } catch {
            print("Error deleting reviews: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func deleteUserReceivedReviews(userId: String) async throws {
        do {
            // get a query of all posts that matches the users id
            let querySnapshot = try await firebaseManager.database
                .collection(firebaseManager.reviewsCollectionName)
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            // Loop through the results and delete each document
            for document in querySnapshot.documents {
                try await document.reference.delete()
                print("Deleted reviews with ID: \(document.documentID)")
            }
            
            print("All user received reviews deleted successfully")
            
        } catch {
            print("Error deleting reviews: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    
    // main function to delete all user related data
    func deleteAllUserData() async throws {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])
        }
        
        do {
            try await deleteUserPosts(userId: userId)
            try await deleteStorageData(userId: userId)
            try await deleteUserReceivedRequest(userId: userId)
            try await deleteUserSentRequest(userId: userId)
            try await deleteUserReceivedReviews(userId: userId)
            try await deleteUserSentReviews(userId: userId)
            try await deleteUserData(userId: userId)
            try await deleteAuthAccount()
            resetAllProperties()
            self.currentUser = nil
            print("All user data successfully deleted")
        } catch {
            print("Error in deleteAllUserData: \(error.localizedDescription)")
            throw error
        }
    }
    

    
    private func updateUserRating(userId: String, newRating: Double) {
        let userRef = firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let currentAverage = document.data()?["averageRating"] as? Double ?? 0.0
                let currentCount = document.data()?["reviewCount"] as? Int ?? 0
                
                let newCount = currentCount + 1
                let newAverage = ((currentAverage * Double(currentCount)) + newRating) / Double(newCount)
                
                userRef.updateData([
                    "averageRating": newAverage,
                    "reviewCount": newCount
                ])
            }
        }
    }
    
    func resetAllProperties() {
        self.currentUser = nil
        self.selectedUser = nil
        self.userReviews = []
        self.loadingState = .idle
        self.userLocation = ""
        self.userLocationCoordinates = nil
        self.showAlert = false
        self.alertMessage = ""
        self.showToast = false
        self.toastMessage = ""
        self.isToastSuccess = false
    }
    
    private func batchDelete(collection: String, field: String, value: String) async throws {
        let batch = firebaseManager.database.batch()
        
        let querySnapshot = try await firebaseManager.database
            .collection(collection)
            .whereField(field, isEqualTo: value)
            .getDocuments()
        
        for document in querySnapshot.documents {
            batch.deleteDocument(document.reference)
        }
        
        try await batch.commit()
        print("Batch deletion completed for \(collection).")
    }

}
