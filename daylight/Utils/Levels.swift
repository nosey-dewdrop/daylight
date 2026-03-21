import Foundation

struct LevelInfo {
    let level: Int
    let name: String
    let xp: Int
    let xpNext: Int

    var progress: Double {
        guard xpNext > 0 else { return 1.0 }
        return Double(xp) / Double(xpNext)
    }
}

enum Levels {
    static let all: [(level: Int, name: String, xp: Int)] = [
        (1, "seedling", 0),
        (2, "sprout", 100),
        (3, "bloom", 300),
        (4, "stargazer", 600),
        (5, "constellation", 1000),
        (6, "aurora", 1500),
        (7, "nebula", 2500),
        (8, "eclipse", 4000),
        (9, "supernova", 6000),
        (10, "cosmos", 10000),
    ]

    static func getInfo(xp: Int) -> LevelInfo {
        var current = all[0]
        var next = all[1]

        for i in stride(from: all.count - 1, through: 0, by: -1) {
            if xp >= all[i].xp {
                current = all[i]
                next = i + 1 < all.count ? all[i + 1] : all[i]
                break
            }
        }

        return LevelInfo(level: current.level, name: current.name, xp: xp, xpNext: next.xp)
    }
}
