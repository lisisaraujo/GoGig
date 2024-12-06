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
    @EnvironmentObject var requestViewModel: RequestViewModel
    @Environment(\.dismiss) private var dismiss
    let serviceProvider: User
    let requestId: String
    
    @State private var rating: Int = 0
    @State private var review: String = ""
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
                .applyBackground()
            
            VStack(spacing: 20) {
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
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            
        }
        .navigationTitle("Rate Service")
    }
    
    private func submitReview() {
        Task {
            guard let currentUserId = authViewModel.currentUser?.id else { return }
            
            let newReview = Review(
                userId: serviceProvider.id!,
                reviewerId: currentUserId,
                requestId: requestId,
                review: review,
                rating: Double(rating)
            )
            
            await authViewModel.addReview(newReview)
            requestViewModel.updateRequestStatus(requestId: requestId, newStatus: .completed, isRated: true)
                dismiss()
            
        }
    }
}

