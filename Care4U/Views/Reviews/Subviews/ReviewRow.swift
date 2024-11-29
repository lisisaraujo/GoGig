//
//  ReviewRow.swift
//  Care4U
//
//  Created by Lisis Ruschel on 12.11.24.
//

import SwiftUI

struct ReviewRow: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(review.rating) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            Text(review.review)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}


//#Preview {
//    ReviewRow(review: <#Review#>)
//}
