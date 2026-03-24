import SwiftUI

struct AvatarView: View {
    let config: AvatarConfig
    var size: CGFloat = 48
    var showBackground: Bool = true

    private var bgColor: Color {
        guard let bg = config.background else { return Theme.bg2 }
        switch bg {
        case "sky_blue": return Color(hex: "B8D4E3")
        case "sunset_pink": return Color(hex: "E8B4B8")
        case "mint_green": return Color(hex: "B8E0D2")
        case "lavender": return Color(hex: "C8B8E0")
        case "peach": return Color(hex: "E8C8A8")
        case "cream": return Color(hex: "F0E8D8")
        case "coral": return Color(hex: "E8A898")
        case "sage": return Color(hex: "B8C8A8")
        default: return Theme.bg2
        }
    }

    var body: some View {
        ZStack {
            if showBackground {
                RoundedRectangle(cornerRadius: 4)
                    .fill(bgColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Theme.brd, lineWidth: 0.5)
                    )
            }

            // Show only head -- crop top portion of character (vesikalik)
            Image(config.assetName)
                .interpolation(.none)
                .resizable()
                .scaledToFill()
                .frame(width: size * 0.85, height: size * 1.0)
                .offset(y: -size * 0.15)
                .clipped()
        }
        .frame(width: size, height: size * 1.2)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// MARK: - Circular avatar for explore/profile headers

struct AvatarCircleView: View {
    let config: AvatarConfig
    var size: CGFloat = 60

    private var bgColor: Color {
        guard let bg = config.background else { return Theme.bg2 }
        switch bg {
        case "sky_blue": return Color(hex: "B8D4E3")
        case "sunset_pink": return Color(hex: "E8B4B8")
        case "mint_green": return Color(hex: "B8E0D2")
        case "lavender": return Color(hex: "C8B8E0")
        case "peach": return Color(hex: "E8C8A8")
        case "cream": return Color(hex: "F0E8D8")
        case "coral": return Color(hex: "E8A898")
        case "sage": return Color(hex: "B8C8A8")
        default: return Theme.bg2
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(bgColor)
                .frame(width: size, height: size)
            Circle()
                .strokeBorder(Theme.brd, lineWidth: 0.5)
                .frame(width: size, height: size)

            Image(config.assetName)
                .interpolation(.none)
                .resizable()
                .scaledToFill()
                .frame(width: size * 0.7, height: size * 0.85)
                .offset(y: -size * 0.08)
                .clipped()
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

#Preview {
    HStack(spacing: 16) {
        AvatarView(config: .default, size: 40)
        AvatarView(config: AvatarConfig(hairStyle: "long", skinTone: "medium"), size: 40)
        AvatarCircleView(config: .default, size: 60)
    }
    .padding()
    .background(Theme.bg)
}
