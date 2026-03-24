import Foundation

struct Interest: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let category: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Interest, rhs: Interest) -> Bool {
        lhs.id == rhs.id
    }
}
