//
//  SenderCardView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 15.11.24.
//
//
//import SwiftUI
//
//struct SenderCardView: View {
//    let senderUser: User?
//    
//    var body: some View {
//        HStack {
//            AsyncImage(url: URL(string: senderUser?.profilePicURL ?? "")) { image in
//                image.resizable()
//            } placeholder: {
//                Image(systemName: "person.circle")
//            }
//            .frame(width: 50, height: 50)
//            .clipShape(Circle())
//            
//            VStack(alignment: .leading) {
//                Text(senderUser?.fullName ?? "Unknown Sender")
//                    .font(.headline)
//                Text("View Profile")
//                    .font(.subheadline)
//                    .foregroundColor(.blue)
//            }
//            
//            Spacer()
//            
//            Image(systemName: "chevron.right")
//                .foregroundColor(.secondary)
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//    }
//}
//#Preview {
//    SenderCardView()
//}
