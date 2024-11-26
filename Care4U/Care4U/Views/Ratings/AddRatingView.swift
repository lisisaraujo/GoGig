//
//  RatingView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import SwiftUI

struct AddRatingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var requestViewModel: ServiceRequestViewModel
    @Environment(\.dismiss) private var dismiss
    let serviceProvider: User
    let serviceRequestId: String
    
    @State private var rating: Int = 0
    @State private var review: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
            Form {
                Section(header: Text("Rate Service Provider")) {
                    HStack {
                        ForEach(1...5, id: \.self) { number in
                            Image(systemName: number <= rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    rating = number
                                }
                        }
                    }
                }
                
                Section(header: Text("Write a Review")) {
                    TextEditor(text: $review)
                        .frame(height: 100)
                }
                
                Button("Submit Review") {
                    submitReview()
                }
            }.applyBackground()
            .navigationTitle("Rate Service")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Review Submitted"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                   dismiss()
                })
            }
        }
    
    private func submitReview() {
        guard let currentUserId = authViewModel.currentUser?.id else { return }
        
        let newReview = Review(
            userId: serviceProvider.id!,
            reviewerId: currentUserId,
            serviceRequestId: serviceRequestId,
            review: review,
            rating: Double(rating)
        )
        
        //add review to firestore
        authViewModel.addReview(newReview) { result in
            switch result {
            case .success:
                requestViewModel.updateRequestStatus(requestId: serviceRequestId, newStatus: .completed, isRated: true)
                alertMessage = "Your review has been submitted successfully."
                
            case .failure(let error):
                alertMessage = "Failed to submit review: \(error.localizedDescription)"
            }
            showAlert = true
        }
    }
}
