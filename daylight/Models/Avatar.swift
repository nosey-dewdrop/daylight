import Foundation
import SwiftUI

struct AvatarConfig: Codable, Hashable {
    var faceShape: FaceShape
    var skinTone: String  // hex color
    var hairStyle: HairStyle
    var hairColor: String  // hex color
    var eyeStyle: EyeStyle
    var eyeColor: String  // hex color
    var eyebrowStyle: EyebrowStyle
    var mouthStyle: MouthStyle
    var clothingStyle: ClothingStyle
    var clothingColor: String  // hex color
    var accessory: Accessory
    var backgroundColor: String  // hex color

    enum FaceShape: String, Codable, CaseIterable, Hashable {
        case round, oval, square, heart
    }

    enum HairStyle: String, Codable, CaseIterable, Hashable {
        case short, medium, long, curly, buzz, bob, ponytail, none
    }

    enum EyeStyle: String, Codable, CaseIterable, Hashable {
        case round, almond, wide, sleepy, wink
    }

    enum EyebrowStyle: String, Codable, CaseIterable, Hashable {
        case thin, thick, arched, straight, bushy
    }

    enum MouthStyle: String, Codable, CaseIterable, Hashable {
        case smile, grin, neutral, smirk, open
    }

    enum ClothingStyle: String, Codable, CaseIterable, Hashable {
        case tshirt, hoodie, shirt, sweater, jacket
    }

    enum Accessory: String, Codable, CaseIterable, Hashable {
        case none, glasses, sunglasses, hat, earrings, headband
    }

    static var `default`: AvatarConfig {
        AvatarConfig(
            faceShape: .round,
            skinTone: "#F5D0A9",
            hairStyle: .medium,
            hairColor: "#4A3728",
            eyeStyle: .round,
            eyeColor: "#5B4A3F",
            eyebrowStyle: .arched,
            mouthStyle: .smile,
            clothingStyle: .tshirt,
            clothingColor: "#7EB5D6",
            accessory: .none,
            backgroundColor: "#B8D4E3"
        )
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        if hex.count == 6 {
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        } else {
            r = 0; g = 0; b = 0
        }
        self.init(red: r, green: g, blue: b)
    }
}
