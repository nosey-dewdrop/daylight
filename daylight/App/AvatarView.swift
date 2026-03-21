import SwiftUI

struct AvatarView: View {
    let emoji: String
    var size: CGFloat = 48
    var bgColor: Color = Theme.bg2

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.25)
                .fill(bgColor)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.25)
                        .strokeBorder(Theme.brd2, lineWidth: 1)
                )
            Text(emoji)
                .font(.system(size: size * 0.5))
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack(spacing: 12) {
        AvatarView(emoji: "🌱", size: 40)
        AvatarView(emoji: "🌸", size: 56)
        AvatarView(emoji: "🌙", size: 64, bgColor: Theme.bg3)
    }
    .padding()
    .background(Theme.bg)
    .preferredColorScheme(.light)
}
