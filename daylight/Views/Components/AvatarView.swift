import SwiftUI

struct AvatarView: View {
    let config: AvatarConfig
    var size: CGFloat = 60

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(Color(hex: config.backgroundColor))
                .frame(width: size, height: size)

            // Body/clothing
            clothingShape
                .offset(y: size * 0.32)

            // Head
            headShape
                .offset(y: -size * 0.05)

            // Hair
            hairShape
                .offset(y: -size * 0.18)

            // Eyes
            eyesView
                .offset(y: -size * 0.02)

            // Eyebrows
            eyebrowsView
                .offset(y: -size * 0.1)

            // Mouth
            mouthView
                .offset(y: size * 0.1)

            // Accessories
            accessoryView
        }
        .clipShape(Circle())
    }

    @ViewBuilder
    private var headShape: some View {
        let skinColor = Color(hex: config.skinTone)
        switch config.faceShape {
        case .round:
            Circle()
                .fill(skinColor)
                .frame(width: size * 0.55, height: size * 0.55)
        case .oval:
            Ellipse()
                .fill(skinColor)
                .frame(width: size * 0.48, height: size * 0.58)
        case .square:
            RoundedRectangle(cornerRadius: size * 0.08)
                .fill(skinColor)
                .frame(width: size * 0.52, height: size * 0.55)
        case .heart:
            Circle()
                .fill(skinColor)
                .frame(width: size * 0.52, height: size * 0.52)
        }
    }

    @ViewBuilder
    private var hairShape: some View {
        let hairColor = Color(hex: config.hairColor)
        switch config.hairStyle {
        case .short:
            Capsule()
                .fill(hairColor)
                .frame(width: size * 0.5, height: size * 0.18)
        case .medium:
            Ellipse()
                .fill(hairColor)
                .frame(width: size * 0.55, height: size * 0.25)
        case .long:
            VStack(spacing: 0) {
                Ellipse()
                    .fill(hairColor)
                    .frame(width: size * 0.55, height: size * 0.25)
                Rectangle()
                    .fill(hairColor)
                    .frame(width: size * 0.5, height: size * 0.2)
            }
        case .curly:
            ZStack {
                Circle().fill(hairColor).frame(width: size * 0.18).offset(x: -size * 0.15)
                Circle().fill(hairColor).frame(width: size * 0.18).offset(x: size * 0.15)
                Circle().fill(hairColor).frame(width: size * 0.18).offset(x: -size * 0.05)
                Circle().fill(hairColor).frame(width: size * 0.18).offset(x: size * 0.05)
                Ellipse().fill(hairColor).frame(width: size * 0.5, height: size * 0.2)
            }
        case .buzz:
            Capsule()
                .fill(hairColor)
                .frame(width: size * 0.48, height: size * 0.12)
        case .bob:
            UnevenRoundedRectangle(
                topLeadingRadius: size * 0.2,
                bottomLeadingRadius: size * 0.05,
                bottomTrailingRadius: size * 0.05,
                topTrailingRadius: size * 0.2
            )
            .fill(hairColor)
            .frame(width: size * 0.56, height: size * 0.3)
        case .ponytail:
            VStack(spacing: 0) {
                Ellipse()
                    .fill(hairColor)
                    .frame(width: size * 0.5, height: size * 0.2)
                Circle()
                    .fill(hairColor)
                    .frame(width: size * 0.12)
                    .offset(x: size * 0.2, y: size * 0.05)
            }
        case .none:
            EmptyView()
        }
    }

    private var eyeSize: (width: CGFloat, height: CGFloat) {
        switch config.eyeStyle {
        case .round: return (size * 0.07, size * 0.07)
        case .almond: return (size * 0.08, size * 0.05)
        case .wide: return (size * 0.09, size * 0.08)
        case .sleepy: return (size * 0.08, size * 0.04)
        case .wink: return (size * 0.07, size * 0.07)
        }
    }

    @ViewBuilder
    private var eyesView: some View {
        let eyeColor = Color(hex: config.eyeColor)
        let ew = eyeSize.width
        let eh = eyeSize.height

        HStack(spacing: size * 0.12) {
            Ellipse()
                .fill(eyeColor)
                .frame(width: ew, height: eh)

            if config.eyeStyle == .wink {
                Capsule()
                    .fill(eyeColor)
                    .frame(width: ew, height: size * 0.02)
            } else {
                Ellipse()
                    .fill(eyeColor)
                    .frame(width: ew, height: eh)
            }
        }
    }

    private var browHeight: CGFloat {
        switch config.eyebrowStyle {
        case .thin: return size * 0.015
        case .thick: return size * 0.03
        case .arched, .straight, .bushy: return size * 0.02
        }
    }

    @ViewBuilder
    private var eyebrowsView: some View {
        let browColor = Color(hex: config.hairColor).opacity(0.8)
        let browWidth = size * 0.1
        let bh = browHeight

        HStack(spacing: size * 0.1) {
            Capsule()
                .fill(browColor)
                .frame(width: browWidth, height: bh)
                .rotationEffect(config.eyebrowStyle == .arched ? .degrees(-8) : .degrees(0))
            Capsule()
                .fill(browColor)
                .frame(width: browWidth, height: bh)
                .rotationEffect(config.eyebrowStyle == .arched ? .degrees(8) : .degrees(0))
        }
    }

    @ViewBuilder
    private var mouthView: some View {
        let mouthColor = Color(hex: "#D4726A")
        switch config.mouthStyle {
        case .smile:
            Capsule()
                .fill(mouthColor)
                .frame(width: size * 0.12, height: size * 0.04)
                .offset(y: size * 0.01)
        case .grin:
            Capsule()
                .fill(mouthColor)
                .frame(width: size * 0.15, height: size * 0.05)
        case .neutral:
            Capsule()
                .fill(mouthColor)
                .frame(width: size * 0.1, height: size * 0.025)
        case .smirk:
            Capsule()
                .fill(mouthColor)
                .frame(width: size * 0.1, height: size * 0.03)
                .rotationEffect(.degrees(5))
        case .open:
            Ellipse()
                .fill(mouthColor)
                .frame(width: size * 0.1, height: size * 0.07)
        }
    }

    @ViewBuilder
    private var accessoryView: some View {
        switch config.accessory {
        case .glasses:
            HStack(spacing: size * 0.04) {
                Circle()
                    .stroke(DaylightTheme.text, lineWidth: size * 0.015)
                    .frame(width: size * 0.14, height: size * 0.14)
                Circle()
                    .stroke(DaylightTheme.text, lineWidth: size * 0.015)
                    .frame(width: size * 0.14, height: size * 0.14)
            }
            .offset(y: -size * 0.02)
        case .sunglasses:
            HStack(spacing: size * 0.04) {
                RoundedRectangle(cornerRadius: size * 0.02)
                    .fill(Color.black.opacity(0.7))
                    .frame(width: size * 0.14, height: size * 0.1)
                RoundedRectangle(cornerRadius: size * 0.02)
                    .fill(Color.black.opacity(0.7))
                    .frame(width: size * 0.14, height: size * 0.1)
            }
            .offset(y: -size * 0.02)
        case .hat:
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: size * 0.03)
                    .fill(DaylightTheme.textSub)
                    .frame(width: size * 0.35, height: size * 0.12)
                Capsule()
                    .fill(DaylightTheme.textSub)
                    .frame(width: size * 0.5, height: size * 0.04)
            }
            .offset(y: -size * 0.3)
        case .earrings:
            HStack(spacing: size * 0.35) {
                Circle()
                    .fill(DaylightTheme.softGold)
                    .frame(width: size * 0.04)
                Circle()
                    .fill(DaylightTheme.softGold)
                    .frame(width: size * 0.04)
            }
            .offset(y: size * 0.08)
        case .headband:
            Capsule()
                .fill(DaylightTheme.pink)
                .frame(width: size * 0.5, height: size * 0.04)
                .offset(y: -size * 0.2)
        case .none:
            EmptyView()
        }
    }

    @ViewBuilder
    private var clothingShape: some View {
        let clothColor = Color(hex: config.clothingColor)
        switch config.clothingStyle {
        case .tshirt:
            UnevenRoundedRectangle(
                topLeadingRadius: size * 0.1,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: size * 0.1
            )
            .fill(clothColor)
            .frame(width: size * 0.6, height: size * 0.3)
        case .hoodie:
            UnevenRoundedRectangle(
                topLeadingRadius: size * 0.12,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: size * 0.12
            )
            .fill(clothColor)
            .frame(width: size * 0.65, height: size * 0.35)
        case .shirt:
            UnevenRoundedRectangle(
                topLeadingRadius: size * 0.08,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: size * 0.08
            )
            .fill(clothColor)
            .frame(width: size * 0.58, height: size * 0.3)
        case .sweater:
            UnevenRoundedRectangle(
                topLeadingRadius: size * 0.12,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: size * 0.12
            )
            .fill(clothColor)
            .frame(width: size * 0.62, height: size * 0.32)
        case .jacket:
            ZStack {
                UnevenRoundedRectangle(
                    topLeadingRadius: size * 0.1,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: size * 0.1
                )
                .fill(clothColor)
                .frame(width: size * 0.65, height: size * 0.35)
                Rectangle()
                    .fill(clothColor.opacity(0.7))
                    .frame(width: size * 0.02, height: size * 0.35)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AvatarView(config: .default, size: 120)
        AvatarView(config: .default, size: 60)
        AvatarView(config: .default, size: 40)
    }
}
