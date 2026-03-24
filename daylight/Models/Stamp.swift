import Foundation

struct Stamp: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let imageName: String
    let category: String
    let xpRequired: Int
    let isPremium: Bool
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageName = "image_name"
        case category
        case xpRequired = "xp_required"
        case isPremium = "is_premium"
        case createdAt = "created_at"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Stamp, rhs: Stamp) -> Bool {
        lhs.id == rhs.id
    }
}

struct UserStamp: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let stampId: UUID
    let unlockedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case stampId = "stamp_id"
        case unlockedAt = "unlocked_at"
    }
}
