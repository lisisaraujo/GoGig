//
//  ReviwerCardView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 13.11.24.
//

import SwiftUI

struct ReviewerCardView: View {
    let reviewer: User?

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: reviewer?.profilePicURL ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.circle")
            }
            .frame(width: 30, height: 30)
            .clipShape(Circle())
            
            Text(reviewer?.fullName ?? "Unknown Reviewer")
                .font(.caption)
                .fontWeight(.semibold)

            Spacer()
        }
    }
}



//#Preview {
//    ReviewerCardView()
//}