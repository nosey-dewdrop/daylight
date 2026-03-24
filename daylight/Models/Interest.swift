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

    static let defaults: [Interest] = [
        // arts
        Interest(id: UUID(), name: "music", category: "arts"),
        Interest(id: UUID(), name: "film", category: "arts"),
        Interest(id: UUID(), name: "photography", category: "arts"),
        Interest(id: UUID(), name: "painting", category: "arts"),
        Interest(id: UUID(), name: "theater", category: "arts"),
        // literature
        Interest(id: UUID(), name: "poetry", category: "literature"),
        Interest(id: UUID(), name: "novels", category: "literature"),
        Interest(id: UUID(), name: "philosophy", category: "literature"),
        Interest(id: UUID(), name: "journalism", category: "literature"),
        // science
        Interest(id: UUID(), name: "astronomy", category: "science"),
        Interest(id: UUID(), name: "psychology", category: "science"),
        Interest(id: UUID(), name: "biology", category: "science"),
        Interest(id: UUID(), name: "technology", category: "science"),
        // lifestyle
        Interest(id: UUID(), name: "travel", category: "lifestyle"),
        Interest(id: UUID(), name: "cooking", category: "lifestyle"),
        Interest(id: UUID(), name: "gardening", category: "lifestyle"),
        Interest(id: UUID(), name: "yoga", category: "lifestyle"),
        Interest(id: UUID(), name: "fashion", category: "lifestyle"),
        // culture
        Interest(id: UUID(), name: "history", category: "culture"),
        Interest(id: UUID(), name: "languages", category: "culture"),
        Interest(id: UUID(), name: "mythology", category: "culture"),
        Interest(id: UUID(), name: "architecture", category: "culture"),
    ]
}
