import Foundation

enum DistanceCalculator {
    /// Haversine formula: calculates distance between two points on Earth in km
    static func haversine(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
        let earthRadiusKm = 6371.0

        let dLat = (lat2 - lat1).degreesToRadians
        let dLng = (lng2 - lng1).degreesToRadians

        let a = sin(dLat / 2) * sin(dLat / 2) +
                cos(lat1.degreesToRadians) * cos(lat2.degreesToRadians) *
                sin(dLng / 2) * sin(dLng / 2)

        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return earthRadiusKm * c
    }

    /// Calculate delivery time based on distance
    /// Same city (~50km): 0.5 hours
    /// Same country (~500km): 4 hours
    /// Nearby countries (~2000km): 12 hours
    /// Far countries (~5000km): 24 hours
    /// Opposite side (~15000km): 48 hours
    /// Maximum: 72 hours
    static func deliveryHours(distanceKm: Double) -> Double {
        let minHours = 0.5
        let maxHours = 72.0
        let maxDistance = 20000.0

        if distanceKm <= 0 { return minHours }

        let fraction = min(distanceKm / maxDistance, 1.0)
        let hours = minHours + (maxHours - minHours) * fraction

        return min(max(hours, minHours), maxHours)
    }

    /// Format hours into human readable countdown
    static func formatCountdown(_ totalSeconds: TimeInterval) -> String {
        if totalSeconds <= 0 { return "Delivered" }

        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60

        if hours > 24 {
            let days = hours / 24
            let remainingHours = hours % 24
            return "\(days)d \(remainingHours)h"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    /// Format distance
    static func formatDistance(_ km: Double) -> String {
        if km < 1 {
            return "\(Int(km * 1000)) m"
        } else if km < 100 {
            return String(format: "%.1f km", km)
        } else {
            return "\(Int(km)) km"
        }
    }
}

private extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
}
