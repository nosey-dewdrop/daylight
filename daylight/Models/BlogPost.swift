import Foundation

struct BlogPost: Codable, Identifiable {
    let id: String
    var authorId: String?
    var title: String
    var slug: String
    var excerpt: String?
    var content: String
    var category: BlogCategory
    var coverImageUrl: String?
    var isFeatured: Bool
    var isApproved: Bool
    var isStaffPick: Bool
    var publishedAt: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case authorId = "author_id"
        case title, slug, excerpt, content, category
        case coverImageUrl = "cover_image_url"
        case isFeatured = "is_featured"
        case isApproved = "is_approved"
        case isStaffPick = "is_staff_pick"
        case publishedAt = "published_at"
        case createdAt = "created_at"
    }
}

enum BlogCategory: String, Codable {
    case mythology
    case historicalLetters = "historical_letters"
    case literaryLove = "literary_love"
    case writingPrompts = "writing_prompts"
    case community
}
