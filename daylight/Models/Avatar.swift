import Foundation

struct Avatar: Codable, Identifiable {
    let id: Int
    var emoji: String
    var name: String
    var xpRequired: Int

    enum CodingKeys: String, CodingKey {
        case id, emoji, name
        case xpRequired = "xp_required"
    }
}
