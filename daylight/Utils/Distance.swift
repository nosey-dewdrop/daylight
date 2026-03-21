import Foundation

enum Distance {
    /// Haversine formula — calculates distance between two coordinates in km
    static func haversine(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R = 6371.0
        let dLat = (lat2 - lat1) * .pi / 180
        let dLon = (lon2 - lon1) * .pi / 180
        let a = pow(sin(dLat / 2), 2) +
            cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) *
            pow(sin(dLon / 2), 2)
        return R * 2 * atan2(sqrt(a), sqrt(1 - a))
    }

    /// Delivery time in hours — distance / 100, min 0.5h
    static func deliveryHours(distanceKm: Double) -> Double {
        max(0.5, distanceKm / 100)
    }

    /// Human-readable time remaining
    static func timeLeft(deliversAt: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: deliversAt) else { return "" }
        let diff = date.timeIntervalSinceNow
        if diff <= 0 { return "arrived" }

        let hours = diff / 3600
        if hours < 1 { return "\(Int(hours * 60))m left" }
        if hours < 24 { return "\(Int(hours))h left" }
        let days = hours / 24
        if days < 2 { return "~1 day left" }
        return "~\(Int(days)) days left"
    }

    /// Journey progress percentage (0-100)
    static func journeyProgress(sentAt: String, deliversAt: String) -> Double {
        let formatter = ISO8601DateFormatter()
        guard let start = formatter.date(from: sentAt),
              let end = formatter.date(from: deliversAt) else { return 100 }

        let now = Date()
        if now >= end { return 100 }
        if now <= start { return 0 }
        return ((now.timeIntervalSince(start)) / (end.timeIntervalSince(start))) * 100
    }

    /// Format date string for display
    static func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return dateString }
        let display = DateFormatter()
        display.dateFormat = "MMM d, yyyy"
        return display.string(from: date)
    }
}
