import SwiftUI

struct GridImageCard: View {
    @Environment(Router.self) var router
    let post: Post

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                
                Group {
                    if let imageUrl = post.postImageUrl, !imageUrl.isEmpty {
                        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageUrl)
                        if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipped()
                        }
                    } else {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.prime1.opacity(0.6), Color.prime1.opacity(0.5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .overlay(
                            Text(post.memo ?? "")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(8)
                        )
                    }
                }
                .onTapGesture {
                    if let project = post.project {
                        router.navigate(to: .ProjectListView(project))
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
