import SwiftUI

struct Header: View {
    var body: some View {
        HStack(spacing: 22) {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 35, height: 35)
                .tint(Color.yellow)

            HStack {
                Text("D-129")
                    .font(.system(size: 11))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1.5)
                    .background(Color.orange.opacity(0.2))
                Text("국민대학교 합격")
                    .font(.system(size: 12, weight: .semibold))
            }

            HStack(spacing: 11) {
                Text("🔥489").font(.system(size: 15, weight: .semibold))
                Text("📒12").font(.system(size: 15, weight: .semibold))
                Text("🎨112").font(.system(size: 15, weight: .semibold))
            }
        }.padding(.vertical, 24)
            .padding(.horizontal, 20)
    }
}
