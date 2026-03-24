import SwiftUI

enum DaylightTheme {
    // MARK: - Core Colors (sahaf palette)
    static let bg = Color.white
    static let text = Color(hex: "#242424")
    static let textSub = Color(hex: "#757575")
    static let textMuted = Color(hex: "#b0b0b0")
    static let rose = Color(hex: "#d4738f")
    static let rule = Color(hex: "#e6e6e6")

    // MARK: - Pastel Accents
    static let yellow = Color(hex: "#fef3c7")
    static let pink = Color(hex: "#fde2e4")
    static let blue = Color(hex: "#d4ecf7")
    static let green = Color(hex: "#d5f0d5")
    static let lavender = Color(hex: "#e8dff5")
    static let peach = Color(hex: "#fde8d0")

    // MARK: - Semantic
    static let parchment = Color(hex: "#FFF8F0")
    static let cream = Color(hex: "#FFF8F0")
    static let waxRed = Color(hex: "#C0392B")
    static let softGold = Color(hex: "#D4A574")
    static let inkBlack = Color(hex: "#2C2C2C")

    // MARK: - Gradients
    static let skyGradient = LinearGradient(
        colors: [blue, Color(hex: "#e8f4fa"), bg],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Fonts (Inter-like via system sans)
    static func heading(_ size: CGFloat) -> Font {
        .system(size: size, weight: .heavy, design: .default)
    }

    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    static func label(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    static func handwriting(_ size: CGFloat) -> Font {
        .system(size: size, design: .serif).italic()
    }

    // MARK: - Presets
    static let titleFont = heading(22)
    static let headlineFont = heading(18)
    static let bodyFont = body(15)
    static let captionFont = label(12)
    static let letterFont = handwriting(17)

    // MARK: - Spacing
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 8
    static let pillRadius: CGFloat = 99
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8

    // MARK: - Pastel array for post-it style cards
    static let pastels: [Color] = [yellow, pink, blue, green, lavender, peach]

    static func pastel(for index: Int) -> Color {
        pastels[index % pastels.count]
    }
}

// MARK: - View Modifiers

struct ParchmentCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(DaylightTheme.parchment)
            .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius)
                    .strokeBorder(DaylightTheme.rule, lineWidth: 1)
            )
    }
}

struct DaylightButton: ViewModifier {
    var isPrimary: Bool = true

    func body(content: Content) -> some View {
        content
            .font(DaylightTheme.label(15))
            .foregroundColor(isPrimary ? .white : DaylightTheme.textSub)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isPrimary ? DaylightTheme.rose : DaylightTheme.bg)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(isPrimary ? Color.clear : DaylightTheme.rule, lineWidth: 1)
            )
    }
}

extension View {
    func parchmentCard() -> some View {
        modifier(ParchmentCard())
    }

    func daylightButton(isPrimary: Bool = true) -> some View {
        modifier(DaylightButton(isPrimary: isPrimary))
    }
}
