import Foundation

struct AppUser: Codable, Identifiable, Hashable {
    let id: String
    var displayName: String?
    var avatarConfig: AvatarConfig?
    var age: Int?
    var country: String?
    var city: String?
    var latitude: Double?
    var longitude: Double?
    var locationVisible: Bool
    var languages: [String]
    var mbti: String?
    var zodiac: String?
    var bio: String?
    var currentBook: String?
    var lastSong: String?
    var lifeMotto: String?
    var interests: [String]
    var xp: Int
    var level: Int
    var isPremium: Bool
    var onboardingComplete: Bool
    var createdAt: Date?
    var lastActiveAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case avatarConfig = "avatar_config"
        case age, country, city
        case latitude, longitude
        case locationVisible = "location_visible"
        case languages, mbti, zodiac, bio
        case currentBook = "current_book"
        case lastSong = "last_song"
        case lifeMotto = "life_motto"
        case interests
        case xp, level
        case isPremium = "is_premium"
        case onboardingComplete = "onboarding_complete"
        case createdAt = "created_at"
        case lastActiveAt = "last_active_at"
    }

    static let empty = AppUser(
        id: "",
        locationVisible: true,
        languages: [],
        interests: [],
        xp: 0,
        level: 1,
        isPremium: false,
        onboardingComplete: false
    )
}
