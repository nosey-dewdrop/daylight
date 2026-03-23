import SwiftUI

// MARK: - Avatar System (hair + skin → preset image)

struct AvatarConfig: Codable, Equatable {
    var hairStyle: String
    var skinTone: String

    var assetName: String {
        "avatar_\(hairStyle)_\(skinTone)"
    }

    static let `default` = AvatarConfig(
        hairStyle: "bob",
        skinTone: "light"
    )
}

struct AvatarOption: Identifiable {
    let id: String
    let label: String
}

enum AvatarCatalog {

    static let hairStyles: [AvatarOption] = [
        AvatarOption(id: "bob", label: "bob"),
        AvatarOption(id: "long", label: "long"),
        AvatarOption(id: "afro", label: "afro"),
        AvatarOption(id: "red_spiky", label: "spiky"),
        AvatarOption(id: "purple_pigtails", label: "pigtails"),
        AvatarOption(id: "blonde_short", label: "short"),
    ]

    static let skinTones: [AvatarOption] = [
        AvatarOption(id: "light", label: "light"),
        AvatarOption(id: "medium", label: "medium"),
        AvatarOption(id: "tan", label: "tan"),
        AvatarOption(id: "dark", label: "dark"),
    ]
}
