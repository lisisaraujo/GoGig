//
//  ReviewCard.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import SwiftUI


struct ReviewCard: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    let review: Review
    @State var reviewerData: User?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ReviewerCardView(reviewer: reviewerData)
                
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= Int(review.rating) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                }
            }
            
            Text(review.review)
                .font(.subheadline)
                .lineLimit(3)
            
            Text(review.timestamp.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundColor(.secondary)
        }.onAppear(perform: {
            Task {
              reviewerData = await authViewModel.fetchUserData(with: review.reviewerId)
            }
        })
        .frame(width: 200, height: 120)
        .padding()
        .cornerRadius(10)
        .shadow(radius: 2)
    }
        
}


