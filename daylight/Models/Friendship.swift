import Foundation

struct Friendship: Codable, Identifiable {
    var id: String?
    let userId: String
    let friendId: String
    var status: FriendshipStatus
    var createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case friendId = "friend_id"
        case status
        case createdAt = "created_at"
    }
}

enum FriendshipStatus: String, Codable {
    case pending
    case accepted
    case blocked
}
