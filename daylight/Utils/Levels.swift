import Foundation

enum LevelSystem {
    /// XP thresholds for each level
    static func xpForLevel(_ level: Int) -> Int {
        guard level > 1 else { return 0 }
        // Quadratic scaling: each level needs more XP
        return Int(pow(Double(level - 1), 1.8) * 100)
    }

    /// Calculate level from XP
    static func levelFromXP(_ xp: Int) -> Int {
        var level = 1
        while xpForLevel(level + 1) <= xp {
            level += 1
        }
        return level
    }

    /// Progress to next level (0.0 to 1.0)
    static func progress(xp: Int) -> Double {
        let currentLevel = levelFromXP(xp)
        let currentLevelXP = xpForLevel(currentLevel)
        let nextLevelXP = xpForLevel(currentLevel + 1)
        let range = nextLevelXP - currentLevelXP
        guard range > 0 else { return 0 }
        return Double(xp - currentLevelXP) / Double(range)
    }

    /// XP rewards
    static let letterSentXP = 25
    static let letterReceivedXP = 10
    static let bottleMailXP = 50
    static let firstLetterXP = 100
    static let newFriendXP = 50
}
