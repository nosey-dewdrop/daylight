import Foundation

struct AppNotification: Codable, Identifiable {
    let id: String
    var userId: String
    var type: String
    var content: String?
    var read: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case type, content, read
        case createdAt = "created_at"
    }
}
