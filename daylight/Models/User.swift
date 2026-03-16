import Foundation
// no dependency in this class, implements few protocols.
struct AppUser: Codable, Identifiable {
    
    // let is constant and var is mutable variable.
    let id: String
    var displayName: String?
    var avatarId: Int?
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
    var soundtrackUrl: String?
    var xp: Int
    var level: Int
    var isPremium: Bool
    var onboardingComplete: Bool
    let createdAt: String
    var lastActiveAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case avatarId = "avatar_id"
        case age, country, city
        case latitude, longitude
        case locationVisible = "location_visible"
        case languages, mbti, zodiac, bio
        case currentBook = "current_book"
        case lastSong = "last_song"
        case lifeMotto = "life_motto"
        case soundtrackUrl = "soundtrack_url"
        case xp, level
        case isPremium = "is_premium"
        case onboardingComplete = "onboarding_complete"
        case createdAt = "created_at"
        case lastActiveAt = "last_active_at"
    }
}
