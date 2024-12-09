
//  ReviewsView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.


import SwiftUI

struct ReviewsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    let userId: String
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(authViewModel.userReviews) { review in
                    ReviewCard(review: review)
                }
            }
            .padding(.vertical)
        }
        .applyBackground()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Reviews")
        .onAppear {
            Task {
                await authViewModel.fetchUserReviews(for: userId)
            }
        }
    }
}
//#Preview {
//    ReviewsView(reviews: <#[Review]#>)
//}
