import SwiftUI

struct GridImageCard: View {
    let post: Post

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                
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
                    Text(post.memo ?? "")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(8)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
