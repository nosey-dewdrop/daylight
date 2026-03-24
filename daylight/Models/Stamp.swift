import Foundation

struct Stamp: Codable, Identifiable, Hashable {
    let id: Int
    var name: String
    var imageName: String
    var category: StampCategory
    var xpRequired: Int
    var isPremium: Bool
    var createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageName = "image_name"
        case category
        case xpRequired = "xp_required"
        case isPremium = "is_premium"
        case createdAt = "created_at"
    }
}

enum StampCategory: String, Codable, CaseIterable, Hashable {
    case flowers
    case animals
    case symbols
    case seasonal
    case extra

    var label: String {
        rawValue.capitalized
    }
}

struct UserStamp: Codable, Identifiable {
    var id: String?
    let userId: String
    let stampId: Int
    var unlockedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case stampId = "stamp_id"
        case unlockedAt = "unlocked_at"
    }
}
