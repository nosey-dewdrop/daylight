import Foundation

struct Letter: Codable, Identifiable {
    let id: String
    var senderId: String?
    var recipientId: String?
    var content: String
    var stampId: Int?
    var songUrl: String?
    var status: LetterStatus
    var isBottle: Bool
    var isMemoryBox: Bool
    var memoryBoxRecipient: String?
    var timeCapsuleDate: String?
    var distanceKm: Double?
    var deliveryHours: Double?
    var sentAt: String?
    var deliversAt: String?
    var readAt: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case senderId = "sender_id"
        case recipientId = "recipient_id"
        case content
        case stampId = "stamp_id"
        case songUrl = "song_url"
        case status
        case isBottle = "is_bottle"
        case isMemoryBox = "is_memory_box"
        case memoryBoxRecipient = "memory_box_recipient"
        case timeCapsuleDate = "time_capsule_date"
        case distanceKm = "distance_km"
        case deliveryHours = "delivery_hours"
        case sentAt = "sent_at"
        case deliversAt = "delivers_at"
        case readAt = "read_at"
        case createdAt = "created_at"
    }
}

enum LetterStatus: String, Codable {
    case draft = "DRAFT"
    case inTransit = "IN_TRANSIT"
    case delivered = "DELIVERED"
    case read = "READ"
    case expired = "EXPIRED"
    case memoryBox = "MEMORY_BOX"

    var label: String {
        switch self {
        case .draft: return "draft"
        case .inTransit: return "in transit"
        case .delivered: return "delivered"
        case .read: return "read"
        case .expired: return "expired"
        case .memoryBox: return "memory"
        }
    }

    var color: String {
        switch self {
        case .inTransit, .draft: return "transit"
        case .delivered: return "delivered"
        case .read, .expired, .memoryBox: return "read"
        }
    }
}
