import Foundation

struct Stamp: Codable, Identifiable {
    let id: Int
    var emoji: String
    var name: String
    var category: String
    var xpRequired: Int
    var isPremium: Bool

    enum CodingKeys: String, CodingKey {
        case id, emoji, name, category
        case xpRequired = "xp_required"
        case isPremium = "is_premium"
    }
}
