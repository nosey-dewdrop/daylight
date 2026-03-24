import Foundation

enum LetterStatus: String, Codable, CaseIterable {
    case draft = "DRAFT"
    case inTransit = "IN_TRANSIT"
    case delivered = "DELIVERED"
    case read = "READ"
}

struct Letter: Codable, Identifiable {
    let id: UUID
    let senderId: UUID
    let recipientId: UUID
    var content: String
    var stampId: UUID?
    var status: LetterStatus
    var isBottle: Bool
    var distanceKm: Double?
    var deliveryHours: Double?
    var sentAt: Date?
    var deliversAt: Date?
    var readAt: Date?
    var createdAt: Date?

    // Joined fields (not always present)
    var sender: Profile?
    var recipient: Profile?

    enum CodingKeys: String, CodingKey {
        case id
        case senderId = "sender_id"
        case recipientId = "recipient_id"
        case content
        case stampId = "stamp_id"
        case status
        case isBottle = "is_bottle"
        case distanceKm = "distance_km"
        case deliveryHours = "delivery_hours"
        case sentAt = "sent_at"
        case deliversAt = "delivers_at"
        case readAt = "read_at"
        case createdAt = "created_at"
        case sender
        case recipient
    }

    var isInTransit: Bool {
        status == .inTransit
    }

    var transitProgress: Double {
        guard let sentAt = sentAt, let deliversAt = deliversAt else { return 0 }
        let total = deliversAt.timeIntervalSince(sentAt)
        let elapsed = Date().timeIntervalSince(sentAt)
        guard total > 0 else { return 1.0 }
        return min(max(elapsed / total, 0), 1.0)
    }

    var timeUntilDelivery: TimeInterval {
        guard let deliversAt = deliversAt else { return 0 }
        return max(deliversAt.timeIntervalSinceNow, 0)
    }
}

struct LetterInsert: Codable {
    let senderId: UUID
    let recipientId: UUID
    let content: String
    let stampId: UUID?
    let status: String
    let isBottle: Bool
    let distanceKm: Double
    let deliveryHours: Double
    let sentAt: Date
    let deliversAt: Date

    enum CodingKeys: String, CodingKey {
        case senderId = "sender_id"
        case recipientId = "recipient_id"
        case content
        case stampId = "stamp_id"
        case status
        case isBottle = "is_bottle"
        case distanceKm = "distance_km"
        case deliveryHours = "delivery_hours"
        case sentAt = "sent_at"
        case deliversAt = "delivers_at"
    }
}
