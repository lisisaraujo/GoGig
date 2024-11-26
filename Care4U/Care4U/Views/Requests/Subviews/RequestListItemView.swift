import SwiftUI

struct RequestListItemView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var serviceRequestViewModel: ServiceRequestViewModel
    let request: ServiceRequest
    @State var userData: User?

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let user = userData, let profilePicURL = user.profilePicURL, let url = URL(string: profilePicURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(userData?.fullName ?? "Unknown")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(request.timestamp, formatter: dateFormatter)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Text(request.message!)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                HStack {
                    Spacer()
                        Circle()
                            .fill(statusColor(for: request.status))
                            .frame(width: 10, height: 10)
                        
                        Text(request.status.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
              
                    }
                }
            }
            .padding()
            .background(Color("surfaceBackground"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .onAppear {
                Task {
                    userData = await authViewModel.fetchUser(with: request.senderUserId)
                }
            }
        }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

#Preview {
    RequestListItemView(request: ServiceRequest(
        id: "12345",
        senderUserId: "user123",
        recipientUserId: "user456",
        postId: "post789",
        status: .accepted,
        timestamp: Date(),
        completionDate: nil,
        message: "I would like to request your service for cleaning my garden.",
        contactInfo: "contact@example.com"
    ))
        .environmentObject(AuthViewModel())
        .environmentObject(ServiceRequestViewModel())
}
