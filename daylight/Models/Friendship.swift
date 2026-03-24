import Foundation

enum FriendshipStatus: String, Codable {
    case pending
    case accepted
    case blocked
}

struct Friendship: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let friendId: UUID
    var status: FriendshipStatus
    let createdAt: Date?
    var updatedAt: Date?

    // Joined
    var friend: Profile?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case friendId = "friend_id"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case friend
    }
}
