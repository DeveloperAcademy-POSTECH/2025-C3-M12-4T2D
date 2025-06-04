import SwiftUI

struct MainHeader: View {
    var user: User?
    var streakNum: Int
    var projectCount: Int
    var postCount: Int
    var body: some View {
        HStack(spacing: 30) {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 49, height: 49)
                .tint(Color.yellow)
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Text(user?.userGoal ?? "목표를 입력하세요")
                        .font(.system(size: 12, weight: .semibold))
                    Text(user != nil ? "D-\(user!.remainingDays)" : "D-0")
                        .font(.system(size: 11))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1.5)
                        .background(Color.orange.opacity(0.2))
                }

                HStack(spacing: 12) {
                    Text("🔥\(streakNum)").font(.system(size: 15, weight: .semibold))
                    Text("📒\(projectCount)").font(.system(size: 15, weight: .semibold))
                    Text("🎨\(postCount)").font(.system(size: 15, weight: .semibold))
                }
            }
            Spacer()
        }.padding(.all, 20)
    }
}
