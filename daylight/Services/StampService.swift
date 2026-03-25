import Foundation
import Supabase

@Observable
final class StampService {
    var allStamps: [Stamp] = []
    var userStamps: [UserStamp] = []
    var unlockedStampIds: Set<UUID> = []
    var isLoading = false

    private let client = SupabaseManager.client

    @MainActor
    func fetchAllStamps() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let stamps: [Stamp] = try await client
                .from("stamps")
                .select()
                .order("category")
                .order("xp_required")
                .execute()
                .value
            allStamps = stamps
        } catch {
            // Error silently handled — stamps will remain empty
        }
    }

    @MainActor
    func fetchUserStamps(userId: UUID) async {
        do {
            let stamps: [UserStamp] = try await client
                .from("user_stamps")
                .select()
                .eq("user_id", value: userId.uuidString)
                .execute()
                .value
            userStamps = stamps
            unlockedStampIds = Set(stamps.map { $0.stampId })
        } catch {
            // Error silently handled — user stamps will remain empty
        }
    }

    @MainActor
    func unlockStamp(userId: UUID, stampId: UUID) async throws {
        struct StampUnlock: Codable {
            let userId: UUID
            let stampId: UUID
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case stampId = "stamp_id"
            }
        }
        try await client
            .from("user_stamps")
            .insert(StampUnlock(userId: userId, stampId: stampId))
            .execute()
        unlockedStampIds.insert(stampId)
    }

    func availableStamps(forXP xp: Int, isPremium: Bool) -> [Stamp] {
        allStamps.filter { stamp in
            let xpOk = stamp.xpRequired <= xp
            let premiumOk = !stamp.isPremium || isPremium
            return xpOk && premiumOk
        }
    }

    func stampsByCategory() -> [String: [Stamp]] {
        Dictionary(grouping: allStamps, by: { $0.category })
    }

    func isUnlocked(_ stamp: Stamp) -> Bool {
        unlockedStampIds.contains(stamp.id)
    }
}
