import SwiftUI

struct RequirementView: View {
    var text: String
    var isMet: Bool

    var body: some View {
        HStack {
            Image(systemName: isMet ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isMet ? .green : .red)
                .animation(.easeInOut(duration: 0.3), value: isMet)

            Text(text)
                .font(.footnote)
                .foregroundColor(isMet ? .gray : .primary)

            Spacer()
        }
        .padding(.vertical, 3)
    }
}

#Preview {
    RequirementView(text: "At least 8 characters", isMet: true)
}
