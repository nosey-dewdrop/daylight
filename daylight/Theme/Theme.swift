import SwiftUI

enum DaylightTheme {
    // MARK: - Colors
    static let babyBlue = Color(hex: "#A8D8EA")
    static let skyBlue = Color(hex: "#7EB5D6")
    static let deepBlue = Color(hex: "#4A90A4")
    static let parchment = Color(hex: "#F5E6D3")
    static let parchmentDark = Color(hex: "#E8D5BC")
    static let warmBrown = Color(hex: "#8B7355")
    static let darkBrown = Color(hex: "#5C4A32")
    static let waxRed = Color(hex: "#C0392B")
    static let softGold = Color(hex: "#D4A574")
    static let cream = Color(hex: "#FFF8F0")
    static let inkBlack = Color(hex: "#2C2C2C")
    static let mutedGreen = Color(hex: "#7EAE7B")
    static let softPink = Color(hex: "#E8B4B8")

    // MARK: - Gradients
    static let skyGradient = LinearGradient(
        colors: [Color(hex: "#87CEEB"), Color(hex: "#A8D8EA"), Color(hex: "#D4F1F9")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let parchmentGradient = LinearGradient(
        colors: [parchment, parchmentDark],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Fonts
    static func typewriter(_ size: CGFloat) -> Font {
        .system(size: size, design: .serif)
    }

    static func handwriting(_ size: CGFloat) -> Font {
        .system(size: size, design: .serif).italic()
    }

    static let titleFont = typewriter(22)
    static let headlineFont = typewriter(18)
    static let bodyFont = typewriter(15)
    static let captionFont = typewriter(12)
    static let letterFont = handwriting(17)

    // MARK: - Spacing
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 8
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
}

// MARK: - View Modifiers

struct ParchmentCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(DaylightTheme.parchment)
            .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius))
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

struct DaylightButton: ViewModifier {
    var isPrimary: Bool = true

    func body(content: Content) -> some View {
        content
            .font(DaylightTheme.headlineFont)
            .foregroundColor(isPrimary ? .white : DaylightTheme.deepBlue)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isPrimary ? DaylightTheme.deepBlue : DaylightTheme.babyBlue.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius))
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
