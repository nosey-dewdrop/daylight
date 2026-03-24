import Foundation

final class StampService {

    // MARK: - Fetch All Stamps

    func fetchAllStamps() async throws -> [Stamp] {
        let stamps: [Stamp] = try await supabase
            .from("stamps")
            .select()
            .order("xp_required", ascending: true)
            .execute()
            .value

        return stamps
    }

    // MARK: - Fetch User's Unlocked Stamps

    func fetchUserStamps(userId: String) async throws -> [Stamp] {
        // Get stamp IDs the user has unlocked
        let userStamps: [UserStamp] = try await supabase
            .from("user_stamps")
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value

        guard !userStamps.isEmpty else { return [] }

        let stampIds = userStamps.map(\.stampId)

        // Fetch full stamp objects
        let stamps: [Stamp] = try await supabase
            .from("stamps")
            .select()
            .in("id", values: stampIds)
            .execute()
            .value

        return stamps
    }

    // MARK: - Unlock a Stamp

    func unlockStamp(userId: String, stampId: Int) async throws {
        let userStamp = UserStamp(
            userId: userId,
            stampId: stampId,
            unlockedAt: Date()
        )

        try await supabase
            .from("user_stamps")
            .insert(userStamp)
            .execute()
    }

    // MARK: - Auto-unlock stamps based on XP

    /// Checks all stamps whose xp_required <= user's current XP
    /// and unlocks any that the user hasn't already earned.
    func checkXPUnlocks(userId: String, xp: Int) async throws {
        // Get all stamps the user could have unlocked by XP
        let eligibleStamps: [Stamp] = try await supabase
            .from("stamps")
            .select()
            .lte("xp_required", value: xp)
            .eq("is_premium", value: false)
            .execute()
            .value

        // Get stamps already unlocked
        let alreadyUnlocked: [UserStamp] = try await supabase
            .from("user_stamps")
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value

        let unlockedIds = Set(alreadyUnlocked.map(\.stampId))

        // Unlock any eligible stamps the user doesn't have yet
        let toUnlock = eligibleStamps.filter { !unlockedIds.contains($0.id) }

        if !toUnlock.isEmpty {
            let rows = toUnlock.map { stamp in
                UserStamp(userId: userId, stampId: stamp.id, unlockedAt: Date())
            }

            try await supabase
                .from("user_stamps")
                .insert(rows)
                .execute()
        }
    }
}
