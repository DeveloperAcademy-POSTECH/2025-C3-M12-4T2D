import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Header()
            // BANNER
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("미래적인 잠자리").font(.system(size: 17, weight: .bold))
                        Text("2025.05.24 ~ 2025.07.02").font(.system(size: 11, weight: .regular))
                    }
                    Spacer()
                    Image(systemName: "ellipsis").foregroundColor(.gray).font(.system(size: 24))
                }.padding(.vertical, 12)
                    .padding(.horizontal, 20)

                ZStack(alignment: .bottom) {
                    // Rectangle -> Image로 바뀔예정
                    Rectangle()
                        .fill(
                            Color.gray
                        )
                        .frame(height: 280)

                    VStack(alignment: .center, spacing: 4) {
                        Text("그림그리는 게 참 어렵다. 아이디어 구상에 시간을 너무 많이...")
                            .foregroundColor(.white)
                            .font(.system(size: 11, weight: .semibold))
                            .lineLimit(1)

                        Text("05.22 13:23pm")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: 11, weight: .regular))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 8) // Horizontal padding몇 ?
                    .padding(.vertical, 10)
//                    #4B4B4B opacity0.4
                    .background(Color(red: 75 / 255, green: 75 / 255, blue: 75 / 255).opacity(0.4))
                }
            }
        }
    }
}

#Preview {
    MainView()
}

