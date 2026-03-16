import SwiftUI

enum Theme {
    // MARK: - Backgrounds
    static let bg = Color(hex: "0C0A10")
    static let bg1 = Color(hex: "13111A")
    static let bg2 = Color(hex: "1A1724")
    static let bg3 = Color(hex: "201D2C")
    static let bg4 = Color(hex: "252030")

    // MARK: - Accent Colors
    static let lilac = Color(hex: "B8A4D6")
    static let lilacLight = Color(hex: "CDBDE8")
    static let pink = Color(hex: "D4A0B9")
    static let pinkLight = Color(hex: "E0B8CC")
    static let gold = Color(hex: "D4B896")
    static let plum = Color(hex: "6B4F7A")

    // MARK: - Text Colors
    static let txt = Color(hex: "EDE8F2")
    static let tx2 = Color(hex: "B0A4BF")
    static let tx3 = Color(hex: "7E7290")
    static let tx4 = Color(hex: "514768")

    // MARK: - Borders
    static let brd = Color(hex: "2A2538")
    static let brd2 = Color(hex: "3A3450")

    // MARK: - Status Colors
    static let transitColor = Color(hex: "D4B896")
    static let deliveredColor = Color(hex: "B8A4D6")
    static let readColor = Color(hex: "7E7290")

    // MARK: - Fonts
    static func displayFont(size: CGFloat) -> Font {
        .custom("Cormorant Garamond", size: size)
    }

    static func bodyFont(size: CGFloat) -> Font {
        .custom("Outfit", size: size)
    }

    static func handFont(size: CGFloat) -> Font {
        .custom("Caveat", size: size)
    }

    // MARK: - Spacing
    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0
        }
        self.init(red: r, green: g, blue: b)
    }
}
