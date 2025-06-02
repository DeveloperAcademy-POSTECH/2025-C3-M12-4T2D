import SwiftUI

struct ImageCard: View {
    let image: String
    var body: some View {
        Image("tmpImage")
            .resizable()
            .frame(width: 193, height: 137)
            .cornerRadius(5)

//        Rectangle().foregroundColor(.gray).frame(width: 193, height: 137).cornerRadius(5)
    }
}
