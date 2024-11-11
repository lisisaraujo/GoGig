
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

class AuthViewModel: ObservableObject {
    
    private let firebaseManager = FirebaseManager.shared
    
    @Published var user: User?
    @Published var loadingState: LoadingStateEnum = .idle
    
    var isUserLoggedIn: Bool {
        return user != nil
    }
    
    init() {
        Task {
            await checkAuth()
        }
    }
    
    func checkAuth() async {
        guard let currentUser = firebaseManager.auth.currentUser else {
            print("Not logged in")
            self.user = nil
            return
        }
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
            DispatchQueue.main.async {
                self.user = fetchedUser
            }
        } catch {
            print("Error fetching user:", error)
            self.user = nil
        }
    }
    
    func logout() {
        do {
            try firebaseManager.auth.signOut()
            self.user = nil
            print("User is logged out")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func register(email: String, password: String, fullName: String, birthDate: Date, location: String, description: String?, latitude: Double?, longitude: Double?, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
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
                
                await createUser(withId: userID, email: email, fullName: fullName, birthDate: birthDate, location: location, description: description, latitude: latitude, longitude: longitude, profilePicUrl: profilePicUrl)
                loadingState = .loaded
                await checkAuth()
                
                completion(true)
                

                
            } catch {
                print("Registration failed:", error.localizedDescription)
                loadingState = .error(error)
                
                DispatchQueue.main.async {
                    completion(false)
                }
            }
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
    
    func login(email: String, password: String) {
        firebaseManager.auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login failed: ", error)
                return
            }
            
            guard let authResult else { return }
            print("User with email '\(authResult.user.email ?? "")' is logged in with id '\(authResult.user.uid)'")
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
                print("Anonymous user logged in with id '\(authResult.user.uid)'")
                Task {
                    await self.fetchUser(with: authResult.user.uid)
                }
            }
        }
    }
    
    func updateUserData(fullName: String?, location: String?, description: String?, latitude: Double?, longitude: Double?, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let userId = user?.id else {
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
                    if let newFullName = updatedFields["fullName"] as? String { self.user?.fullName = newFullName }
                    if let newLocation = updatedFields["location"] as? String { self.user?.location = newLocation }
                    if let newLatitude = updatedFields["latitude"] as? Double { self.user?.latitude = newLatitude }
                    if let newLongitude = updatedFields["longitude"] as? Double { self.user?.longitude = newLongitude }
                    if let newDescription = updatedFields["description"] as? String { self.user?.description = newDescription }
                    if let newProfilePicUrl = updatedFields["profilePicURL"] as? String { self.user?.profilePicURL = newProfilePicUrl }

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
    private func deleteFirestoreData(userId: String) async throws {
          do {
              try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId).delete()
              print("User Firestore data deleted successfully")
          } catch {
              print("Error deleting Firestore data: \(error.localizedDescription)")
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
              // We're not throwing this error as it's not critical if the profile picture is already gone
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

      // main function to delete all user related data
      func deleteAllUserData() async throws {
          guard let userId = user?.id else {
              throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])
          }

          do {
            
              try await deleteFirestoreData(userId: userId)

              try await deleteStorageData(userId: userId)

              try await deleteAuthAccount()
              
              logout()

              self.user = nil

              print("All user data successfully deleted")
          } catch {
              print("Error in deleteAllUserData: \(error.localizedDescription)")
              throw error
          }
      }
    
    
    
}
