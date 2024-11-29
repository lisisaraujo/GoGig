//
//  RatingView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import SwiftUI
struct RatingView: View {
    let rating: Double
    let reviewCount: Int
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= Int(rating.rounded()) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            Text(String(format: "%.1f", rating))
                .fontWeight(.bold)
            Text("(\(reviewCount) reviews)")
                .foregroundColor(.secondary)
        }
    }
}
