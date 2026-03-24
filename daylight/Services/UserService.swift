import Foundation

final class UserService {

    // MARK: - Profile

    func fetchProfile(userId: String) async throws -> AppUser {
        let user: AppUser = try await supabase
            .from("profiles")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
            .value

        return user
    }

    func updateProfile(_ profile: AppUser) async throws {
        try await supabase
            .from("profiles")
            .update(profile)
            .eq("id", value: profile.id)
            .execute()
    }

    // MARK: - Onboarding

    func completeOnboarding(
        userId: String,
        displayName: String,
        avatarConfig: AvatarConfig,
        interests: [String],
        languages: [String],
        country: String
    ) async throws {
        let payload = OnboardingPayload(
            displayName: displayName,
            avatarConfig: avatarConfig,
            interests: interests,
            languages: languages,
            country: country,
            onboardingComplete: true,
            lastActiveAt: Date()
        )

        try await supabase
            .from("profiles")
            .update(payload)
            .eq("id", value: userId)
            .execute()
    }

    // MARK: - Pen Pal Search

    /// Search for potential pen pals who share interests or languages.
    /// Excludes the provided user IDs (self + already connected users).
    func searchPenPals(
        interests: [String],
        languages: [String],
        excludeIds: [String]
    ) async throws -> [AppUser] {
        var query = supabase
            .from("profiles")
            .select()
            .eq("onboarding_complete", value: true)

        // Exclude specific users (self, existing pen pals)
        for excludeId in excludeIds {
            query = query.neq("id", value: excludeId)
        }

        // Filter by shared languages if provided
        if !languages.isEmpty {
            query = query.overlaps("languages", value: languages)
        }

        let users: [AppUser] = try await query
            .limit(50)
            .execute()
            .value

        // Sort by number of shared interests client-side
        if !interests.isEmpty {
            let interestSet = Set(interests)
            return users.sorted { a, b in
                let aMatch = Set(a.interests).intersection(interestSet).count
                let bMatch = Set(b.interests).intersection(interestSet).count
                return aMatch > bMatch
            }
        }

        return users
    }
}

// MARK: - Onboarding Payload

private struct OnboardingPayload: Codable {
    let displayName: String
    let avatarConfig: AvatarConfig
    let interests: [String]
    let languages: [String]
    let country: String
    let onboardingComplete: Bool
    let lastActiveAt: Date

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case avatarConfig = "avatar_config"
        case interests, languages, country
        case onboardingComplete = "onboarding_complete"
        case lastActiveAt = "last_active_at"
    }
}
