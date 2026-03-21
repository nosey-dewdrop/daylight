import SwiftUI

enum Theme {
    // MARK: - Backgrounds (baby blue / typewriter)
    static let bg = Color(hex: "C8D5E0")   // soft baby blue
    static let bg1 = Color(hex: "D4DFE8")  // lighter card bg
    static let bg2 = Color(hex: "DDE6EE")  // subtle panel
    static let bg3 = Color(hex: "B8C8D6")  // pressed/active
    static let bg4 = Color(hex: "A8BCCC")  // deeper accent bg

    // MARK: - Accent Colors
    static let lilac = Color(hex: "7B8BA4")   // muted slate blue
    static let lilacLight = Color(hex: "9AACBE")
    static let pink = Color(hex: "C4707F")    // wax seal red
    static let pinkLight = Color(hex: "D4909C")
    static let gold = Color(hex: "C4A66A")    // warm gold ink
    static let plum = Color(hex: "6B7A8A")

    // MARK: - Text Colors
    static let txt = Color(hex: "2A2A3A")    // dark ink
    static let tx2 = Color(hex: "4A4A5E")   // medium text
    static let tx3 = Color(hex: "6E7888")   // faded text
    static let tx4 = Color(hex: "94A0AC")   // very faded

    // MARK: - Borders
    static let brd = Color(hex: "B0BCC8")
    static let brd2 = Color(hex: "9AAAB8")

    // MARK: - Status Colors
    static let transitColor = Color(hex: "C4A66A")  // gold — in transit
    static let deliveredColor = Color(hex: "7B8BA4") // blue — delivered
    static let readColor = Color(hex: "94A0AC")      // gray — read

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

    static func typeFont(size: CGFloat) -> Font {
        .custom("Courier New", size: size)
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
