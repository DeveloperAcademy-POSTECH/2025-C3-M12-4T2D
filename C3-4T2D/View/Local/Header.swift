import SwiftUI

struct Header: View {
    var body: some View {
        HStack(spacing: 30) {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 49, height: 49)
                .tint(Color.yellow)
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Text("국민대학교 합격")
                        .font(.system(size: 12, weight: .semibold))
                    Text("D-129")
                        .font(.system(size: 11))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1.5)
                        .background(Color.orange.opacity(0.2))
                }

                HStack(spacing: 12) {
                    Text("🔥489").font(.system(size: 15, weight: .semibold))
                    Text("📒12").font(.system(size: 15, weight: .semibold))
                    Text("🎨112").font(.system(size: 15, weight: .semibold))
                }
            }
            Spacer()
        }.padding(.vertical, 24)
            .padding(.horizontal, 20)
    }
}
