import SwiftUI

/// Rectangular stamp with perforated edges
struct StampShape: Shape {
    var perforationRadius: CGFloat = 3
    var perforationSpacing: CGFloat = 8

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let inset = perforationRadius * 2

        // Main rectangle inset
        let innerRect = rect.insetBy(dx: inset, dy: inset)
        path.addRoundedRect(in: innerRect, cornerSize: CGSize(width: 2, height: 2))

        // Top edge perforations
        var x = rect.minX + perforationSpacing
        while x < rect.maxX {
            path.addEllipse(in: CGRect(
                x: x - perforationRadius,
                y: rect.minY,
                width: perforationRadius * 2,
                height: perforationRadius * 2
            ))
            x += perforationSpacing
        }

        // Bottom edge perforations
        x = rect.minX + perforationSpacing
        while x < rect.maxX {
            path.addEllipse(in: CGRect(
                x: x - perforationRadius,
                y: rect.maxY - perforationRadius * 2,
                width: perforationRadius * 2,
                height: perforationRadius * 2
            ))
            x += perforationSpacing
        }

        // Left edge perforations
        var y = rect.minY + perforationSpacing
        while y < rect.maxY {
            path.addEllipse(in: CGRect(
                x: rect.minX,
                y: y - perforationRadius,
                width: perforationRadius * 2,
                height: perforationRadius * 2
            ))
            y += perforationSpacing
        }

        // Right edge perforations
        y = rect.minY + perforationSpacing
        while y < rect.maxY {
            path.addEllipse(in: CGRect(
                x: rect.maxX - perforationRadius * 2,
                y: y - perforationRadius,
                width: perforationRadius * 2,
                height: perforationRadius * 2
            ))
            y += perforationSpacing
        }

        return path
    }
}

struct StampView: View {
    let stamp: Stamp
    var width: CGFloat = 60
    var isUnlocked: Bool = true

    private var height: CGFloat { width * 1.3 }

    var body: some View {
        ZStack {
            // Stamp background with perforated edges
            StampShape(perforationRadius: 2, perforationSpacing: 6)
                .fill(stampColor)
                .frame(width: width, height: height)

            // Stamp content
            VStack(spacing: 2) {
                // Icon based on category
                stampIcon
                    .font(.system(size: width * 0.3))

                Text(stamp.name)
                    .font(DaylightTheme.captionFont)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .frame(width: width - 16)
            }
            .padding(4)

            if !isUnlocked {
                Color.black.opacity(0.5)
                    .clipShape(StampShape(perforationRadius: 2, perforationSpacing: 6))
                    .frame(width: width, height: height)

                Image(systemName: "lock.fill")
                    .foregroundColor(.white)
                    .font(.system(size: width * 0.25))
            }
        }
    }

    private var stampColor: Color {
        switch stamp.category {
        case "Welcome": return DaylightTheme.green
        case "Nature": return Color(hex: "#5B8C5A")
        case "Cities": return DaylightTheme.rose
        case "Seasons": return Color(hex: "#D4926A")
        case "Zodiac": return Color(hex: "#7B68AE")
        case "Premium": return DaylightTheme.softGold
        default: return DaylightTheme.blue
        }
    }

    @ViewBuilder
    private var stampIcon: some View {
        switch stamp.imageName {
        case "stamp_first_letter": Text("✉️")
        case "stamp_hello_world": Text("🌍")
        case "stamp_sunrise": Text("🌅")
        case "stamp_paper_plane": Text("✈️")
        case "stamp_quill_pen": Text("🖋")
        case "stamp_mountain": Text("🏔")
        case "stamp_ocean": Text("🌊")
        case "stamp_cherry_blossom": Text("🌸")
        case "stamp_northern_lights": Text("🌌")
        case "stamp_desert_sunset": Text("🏜")
        case "stamp_rainforest": Text("🌳")
        case "stamp_tokyo": Text("🗼")
        case "stamp_paris": Text("🗼")
        case "stamp_london": Text("🕐")
        case "stamp_new_york": Text("🗽")
        case "stamp_rome": Text("🏛")
        case "stamp_taj_mahal": Text("🕌")
        case "stamp_great_wall": Text("🏯")
        case "stamp_sydney": Text("🎭")
        case "stamp_spring": Text("🌷")
        case "stamp_summer": Text("☀️")
        case "stamp_autumn": Text("🍂")
        case "stamp_winter": Text("❄️")
        case "stamp_golden_envelope": Text("💌")
        case "stamp_crystal_ball": Text("🔮")
        case "stamp_phoenix": Text("🔥")
        default:
            // Zodiac and others
            Text("⭐️")
        }
    }
}

#Preview {
    HStack {
        StampView(stamp: Stamp(
            id: UUID(),
            name: "First Letter",
            imageName: "stamp_first_letter",
            category: "Welcome",
            xpRequired: 0,
            isPremium: false,
            createdAt: nil
        ))
        StampView(stamp: Stamp(
            id: UUID(),
            name: "Mountain Peak",
            imageName: "stamp_mountain",
            category: "Nature",
            xpRequired: 100,
            isPremium: false,
            createdAt: nil
        ), isUnlocked: false)
    }
}
