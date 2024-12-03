////
////  UsersViewModel.swift
////  Care4U
////
////  Created by Lisis Ruschel on 12.11.24.
////
//
//import Foundation
//import FirebaseAuth
//import FirebaseStorage
//import PhotosUI
//import CoreLocation
//
//@MainActor
//class UserViewModel: ObservableObject {
//    private let userRepository = UserRepository()
//    private let firebaseManager = FirebaseManager.shared
//    
//    
//    @Published var selectedUser: User?
//    @Published var userReviews: [Review] = []
//    @Published var loadingState: LoadingStateEnum = .idle
//    
//    init() {
//        Task {
//            await checkAuth()
//        }
//    }
//    
//    func checkAuth() async {
//        guard let currentUserId = firebaseManager.auth.currentUser?.uid else {
//            print("Not logged in")
//            self.currentUser = nil
//            return
//        }
//        await fetchUserAndReviews(with: currentUserId)
//    }
//    
//    
//    func register(email: String, password: String, fullName: String, birthDate: Date, location: String, description: String?, latitude: Double?, longitude: Double?, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
//        loadingState = .loading
//        
//        Task {
//            do {
//                let authResult = try await firebaseManager.auth.createUser(withEmail: email, password: password)
//                let userID = authResult.user.uid
//                print("User with email '\(email)' is registered with id '\(userID)'")
//                
//                var profilePicUrl: String? = nil
//                if let image = profileImage {
//                    profilePicUrl = await uploadProfilePicture(image, for: userID)
//                }
//                
//                await createUser(withId: userID, email: email, fullName: fullName, birthDate: birthDate, location: location, description: description, latitude: latitude, longitude: longitude, profilePicUrl: profilePicUrl)
//                loadingState = .loaded
//                await checkAuth()
//                
//                completion(true)
//                
//
//                
//            } catch {
//                print("Registration failed:", error.localizedDescription)
//                loadingState = .error(error)
//                
//                DispatchQueue.main.async {
//                    completion(false)
//                }
//            }
//        }
//    }
//    
//    func fetchSelectedUser(with id: String) async {
//           await fetchUserAndReviews(with: id)
//       }
//       
//       private func fetchUserAndReviews(with id: String) async {
//           do {
//               let document = try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(id).getDocument()
//               
//               guard document.exists else {
//                   print("No such document!")
//                   resetUserData(for: id)
//                   return
//               }
//
//               let fetchedUser = try document.data(as: User.self)
//               if id == currentUser?.id {
//                   self.currentUser = fetchedUser
//               } else {
//                   self.selectedUser = fetchedUser
//                   self.userReviews = await getUserReviews(for: id)
//               }
//           } catch {
//               print("Error fetching user:", error)
//               resetUserData(for: id)
//           }
//       }
//
//       private func resetUserData(for id: String) {
//           if id == currentUser?.id {
//               self.currentUser = nil
//           } else {
//               self.selectedUser = nil
//           }
//       }
//    
//    private func getUserReviews(for userId: String) async -> [Review] {
//        do {
//            let reviewsQuery = firebaseManager.database.collection("reviews").whereField("userId", isEqualTo: userId)
//            let snapshot = try await reviewsQuery.getDocuments()
//            return snapshot.documents.compactMap { try? $0.data(as: Review.self) }
//        } catch {
//            print("Error fetching user reviews:", error.localizedDescription)
//            return []
//        }
//    }
//
// 
// func fetchUser(with userId: String) async -> User? {
//     do {
//         let document = try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId).getDocument()
//         return try document.data(as: User.self)
//     } catch {
//         print("Error fetching user:", error.localizedDescription)
//         return nil
//     }
// }
// 
//    private func createUser(withId id: String, email: String, fullName: String, birthDate: Date, location: String, description: String?, latitude: Double?, longitude: Double?, profilePicUrl: String?) async {
//        let user = User(id: id, email: email, fullName: fullName, birthDate: birthDate, location: location, description: description, latitude: latitude, longitude: longitude, memberSince: Date(), profilePicURL: profilePicUrl)
//        
//        do {
//            try firebaseManager.database.collection(firebaseManager.usersCollectionName).document(id).setData(from: user)
//            
//        } catch {
//            print("Saving user failed:", error)
//        }
//    }
//    
//    
//     func uploadProfilePicture(_ image: UIImage, for userID: String) async -> String? {
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            print("Error converting image to data")
//            return nil
//        }
//        
//         let storageRef = firebaseManager.storage.reference().child("\(firebaseManager.profilePicStorageRef)/\(userID).jpg")
//        
//        do {
//            _ = try await storageRef.putDataAsync(imageData)
//            let url = try await storageRef.downloadURL()
//            return url.absoluteString
//        } catch {
//            print("Error uploading image or getting download URL:", error)
//            return nil
//        }
//    }
//    
// 
//   
//    func updateUserData(fullName: String?, location: String?, description: String?, latitude: Double?, longitude: Double?, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
//        guard let userId = currentUser?.id else {
//            completion(false)
//            return
//        }
//
//        loadingState = .loading
//        Task {
//            var updatedFields: [String: Any] = [:]
//            
//            // update full name if provided
//            if let newFullName = fullName {
//                updatedFields["fullName"] = newFullName
//            }
//            
//            // update location and coordinates
//            if let newLocation = location {
//                updatedFields["location"] = newLocation
//            }
//            if let newLatitude = latitude {
//                updatedFields["latitude"] = newLatitude
//            }
//            if let newLongitude = longitude {
//                updatedFields["longitude"] = newLongitude
//            }
//            
//            // update description
//            if let newDescription = description {
//                updatedFields["description"] = newDescription
//            }
//            
//            // upload new profile pic
//            if let newImage = profileImage {
//                if let profilePicUrl = await uploadProfilePicture(newImage, for: userId) {
//                    updatedFields["profilePicURL"] = profilePicUrl
//                }
//            }
//
//            // update firestore if there are any fields to update
//            if !updatedFields.isEmpty {
//                do {
//                    try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId).updateData(updatedFields)
//                    
//                    // update local user properties with changes
//                    if let newFullName = updatedFields["fullName"] as? String { self.currentUser?.fullName = newFullName }
//                    if let newLocation = updatedFields["location"] as? String { self.currentUser?.location = newLocation }
//                    if let newLatitude = updatedFields["latitude"] as? Double { self.currentUser?.latitude = newLatitude }
//                    if let newLongitude = updatedFields["longitude"] as? Double { self.currentUser?.longitude = newLongitude }
//                    if let newDescription = updatedFields["description"] as? String { self.currentUser?.description = newDescription }
//                    if let newProfilePicUrl = updatedFields["profilePicURL"] as? String { self.currentUser?.profilePicURL = newProfilePicUrl }
//
//                    loadingState = .loaded
//                    completion(true)
//                    
//                } catch {
//                    print("Error updating user data:", error.localizedDescription)
//                    loadingState = .error(error)
//                    completion(false)
//                }
//            } else {
//                loadingState = .loaded
//                completion(true)
//            }
//        }
//    }
//
//     
//    
//    // delete firestore user data
//    private func deleteUserData(userId: String) async throws {
//          do {
//              try await firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId).delete()
//              print("User Firestore data deleted successfully")
//          } catch {
//              print("Error deleting Firestore data: \(error.localizedDescription)")
//              throw error
//          }
//      }
//    
//    // delete firestore user data
//    private func deleteUserPosts(userId: String) async throws {
//        do {
//     
//            // get a query of all posts that matches the users id
//            let querySnapshot = try await firebaseManager.database
//                .collection(firebaseManager.postsCollectionName)
//                .whereField("userId", isEqualTo: userId)
//                .getDocuments()
//            
//            //lLoop through the results and delete each document
//            for document in querySnapshot.documents {
//                try await document.reference.delete()
//                print("Deleted post with ID: \(document.documentID)")
//            }
//            
//            print("All user posts deleted successfully")
//            
//        } catch {
//            print("Error deleting user posts: \(error.localizedDescription)")
//            throw error
//        }
//    }
//
//
//      // delete Storage Data (profilePic)
//      private func deleteStorageData(userId: String) async throws {
//          let storageRef = Storage.storage().reference().child("\(firebaseManager.profilePicStorageRef)/\(userId).jpg")
//          do {
//              try await storageRef.delete()
//              print("User profile picture deleted successfully")
//          } catch {
//              print("Profile picture not found or already deleted: \(error.localizedDescription)")
//          }
//      }
//
//      // delete auth account
//      private func deleteAuthAccount() async throws {
//          guard let currentUser = Auth.auth().currentUser else {
//              throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found in Firebase Auth"])
//          }
//          do {
//              try await currentUser.delete()
//              print("User authentication account deleted successfully")
//          } catch {
//              print("Error deleting authentication account: \(error.localizedDescription)")
//              throw error
//          }
//      }
//
//      // main function to delete all user related data
//      func deleteAllUserData() async throws {
//          guard let userId = currentUser?.id else {
//              throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])
//          }
//
//          do {
//            
//              try await deleteUserData(userId: userId)
//              
//              try await deleteUserPosts(userId: userId)
//
//              try await deleteStorageData(userId: userId)
//
//              try await deleteAuthAccount()
//              
//              logout()
//
//              self.currentUser = nil
//
//              print("All user data successfully deleted")
//          } catch {
//              print("Error in deleteAllUserData: \(error.localizedDescription)")
//              throw error
//          }
//      }
//    
//    
//    func addReview(_ review: Review, completion: @escaping (Result<Void, Error>) -> Void) {
//        do {
//            try firebaseManager.database.collection(firebaseManager.reviewsCollectionName).addDocument(from: review) { error in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    // Update the user's average rating and review count
//                    self.updateUserRating(userId: review.userId, newRating: review.rating)
//                    completion(.success(()))
//                }
//            }
//        } catch {
//            completion(.failure(error))
//        }
//    }
//
//    private func updateUserRating(userId: String, newRating: Double) {
//        let userRef = firebaseManager.database.collection(firebaseManager.usersCollectionName).document(userId)
//        
//        userRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let currentAverage = document.data()?["averageRating"] as? Double ?? 0.0
//                let currentCount = document.data()?["reviewCount"] as? Int ?? 0
//                
//                let newCount = currentCount + 1
//                let newAverage = ((currentAverage * Double(currentCount)) + newRating) / Double(newCount)
//                
//                userRef.updateData([
//                    "averageRating": newAverage,
//                    "reviewCount": newCount
//                ])
//            }
//        }
//    }
//}
