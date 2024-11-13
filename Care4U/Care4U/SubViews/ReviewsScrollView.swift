//
//  ReviewsScrollView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import Foundation
import SwiftUI

struct ReviewsScrollView: View {
    let reviews: [Review]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reviews")
                .font(.headline)
                .padding(.bottom, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(reviews) { review in
                        ReviewCard(review: review)
                    }
                }
            }
        }
    }
}
