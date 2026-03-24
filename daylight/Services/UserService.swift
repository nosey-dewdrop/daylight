import Foundation
import Supabase

@Observable
final class UserService {
    var searchResults: [Profile] = []
    var friends: [Friendship] = []
    var allInterests: [Interest] = []
    var isLoading = false

    private let client = SupabaseManager.client

    @MainActor
    func updateProfile(_ update: ProfileUpdate, userId: UUID) async throws {
        try await client
            .from("profiles")
            .update(update)
            .eq("id", value: userId.uuidString)
            .execute()
    }

    @MainActor
    func fetchInterests() async {
        do {
            let interests: [Interest] = try await client
                .from("interests")
                .select()
                .order("category")
                .execute()
                .value
            if !interests.isEmpty {
                allInterests = interests
            } else {
                allInterests = Interest.defaults
            }
        } catch {
            print("Failed to fetch interests: \(error)")
            allInterests = Interest.defaults
        }
    }

    @MainActor
    func searchPenPals(
        excludeUserId: UUID,
        country: String? = nil,
        language: String? = nil,
        interest: String? = nil,
        minAge: Int? = nil,
        maxAge: Int? = nil
    ) async {
        isLoading = true
        defer { isLoading = false }
        do {
            var query = client
                .from("profiles")
                .select()
                .neq("id", value: excludeUserId.uuidString)
                .eq("onboarding_complete", value: true)

            if let country = country, !country.isEmpty {
                query = query.eq("country", value: country)
            }
            if let language = language, !language.isEmpty {
                query = query.contains("languages", value: [language])
            }
            if let interest = interest, !interest.isEmpty {
                query = query.contains("interests", value: [interest])
            }
            if let minAge = minAge {
                query = query.gte("age", value: minAge)
            }
            if let maxAge = maxAge {
                query = query.lte("age", value: maxAge)
            }

            let profiles: [Profile] = try await query
                .limit(50)
                .execute()
                .value
            searchResults = profiles
        } catch {
            print("Failed to search: \(error)")
        }
    }

    @MainActor
    func fetchFriends(userId: UUID) async {
        do {
            let friendships: [Friendship] = try await client
                .from("friendships")
                .select("*, friend:profiles!friendships_friend_id_fkey(*)")
                .eq("user_id", value: userId.uuidString)
                .eq("status", value: "accepted")
                .execute()
                .value
            friends = friendships
        } catch {
            print("Failed to fetch friends: \(error)")
        }
    }

    @MainActor
    func sendFriendRequest(userId: UUID, friendId: UUID) async throws {
        struct FriendInsert: Codable {
            let userId: UUID
            let friendId: UUID
            let status: String
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case friendId = "friend_id"
                case status
            }
        }
        // Create bidirectional friendship entries
        try await client.from("friendships").insert(
            FriendInsert(userId: userId, friendId: friendId, status: "pending")
        ).execute()
    }

    @MainActor
    func acceptFriendRequest(friendshipId: UUID) async throws {
        try await client
            .from("friendships")
            .update(["status": "accepted"])
            .eq("id", value: friendshipId.uuidString)
            .execute()
    }

    @MainActor
    func getRandomPenPal(excludeUserId: UUID) async -> Profile? {
        do {
            let profiles: [Profile] = try await client
                .from("profiles")
                .select()
                .neq("id", value: excludeUserId.uuidString)
                .eq("onboarding_complete", value: true)
                .limit(1)
                .execute()
                .value
            return profiles.first
        } catch {
            print("Failed to get random pen pal: \(error)")
            return nil
        }
    }

    @MainActor
    func fetchProfile(userId: UUID) async -> Profile? {
        do {
            let profile: Profile = try await client
                .from("profiles")
                .select()
                .eq("id", value: userId.uuidString)
                .single()
                .execute()
                .value
            return profile
        } catch {
            return nil
        }
    }
}
