import Foundation

struct Profile: Codable, Identifiable, Hashable {
    let id: UUID
    var displayName: String?
    var avatarConfig: AvatarConfig?
    var age: Int?
    var country: String?
    var city: String?
    var latitude: Double?
    var longitude: Double?
    var languages: [String]?
    var interests: [String]?
    var mbti: String?
    var zodiac: String?
    var bio: String?
    var xp: Int?
    var level: Int?
    var isPremium: Bool?
    var onboardingComplete: Bool?
    var lastSeen: Date?
    var createdAt: Date?
    var updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case avatarConfig = "avatar_config"
        case age, country, city
        case latitude, longitude
        case languages, interests
        case mbti, zodiac, bio, xp, level
        case isPremium = "is_premium"
        case onboardingComplete = "onboarding_complete"
        case lastSeen = "last_seen"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Profile, rhs: Profile) -> Bool {
        lhs.id == rhs.id
    }
}

struct ProfileUpdate: Codable {
    var displayName: String?
    var avatarConfig: AvatarConfig?
    var age: Int?
    var country: String?
    var city: String?
    var latitude: Double?
    var longitude: Double?
    var languages: [String]?
    var interests: [String]?
    var mbti: String?
    var zodiac: String?
    var bio: String?
    var xp: Int?
    var level: Int?
    var onboardingComplete: Bool?

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case avatarConfig = "avatar_config"
        case age, country, city
        case latitude, longitude
        case languages, interests
        case mbti, zodiac, bio, xp, level
        case onboardingComplete = "onboarding_complete"
    }
}
