import SwiftUI

struct AvatarView: View {
    let config: AvatarConfig
    var size: CGFloat = 48
    var showBackground: Bool = true

    var body: some View {
        ZStack {
            if showBackground {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Theme.bg1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Theme.brd, lineWidth: 0.5)
                    )
            }

            // Show only head — crop top portion of character (vesikalık)
            Image(config.assetName)
                .interpolation(.none)
                .resizable()
                .scaledToFill()
                .frame(width: size * 0.85, height: size * 1.0)
                .offset(y: -size * 0.15) // shift up to show head, not feet
                .clipped()
        }
        .frame(width: size, height: size * 1.2)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    HStack(spacing: 16) {
        AvatarView(config: .default, size: 40)
        AvatarView(config: AvatarConfig(hairStyle: "long", skinTone: "medium"), size: 40)
        AvatarView(config: AvatarConfig(hairStyle: "afro", skinTone: "dark"), size: 40)
    }
    .padding()
    .background(Theme.bg)
}
