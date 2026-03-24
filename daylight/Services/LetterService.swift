import Foundation
import Supabase

final class LetterService {

    // MARK: - Private

    private var inboxChannel: RealtimeChannel?

    // MARK: - Fetch

    func fetchInbox(userId: String) async throws -> [Letter] {
        let letters: [Letter] = try await supabase
            .from("letters")
            .select()
            .eq("recipient_id", value: userId)
            .order("created_at", ascending: false)
            .execute()
            .value

        return letters
    }

    func fetchSent(userId: String) async throws -> [Letter] {
        let letters: [Letter] = try await supabase
            .from("letters")
            .select()
            .eq("sender_id", value: userId)
            .order("created_at", ascending: false)
            .execute()
            .value

        return letters
    }

    /// Fetches letters that are still IN_TRANSIT but whose delivers_at has passed,
    /// updates their status to DELIVERED, and returns them.
    func fetchDeliveredLetters() async throws -> [Letter] {
        let now = ISO8601DateFormatter().string(from: Date())

        // Find letters that should have arrived by now
        let letters: [Letter] = try await supabase
            .from("letters")
            .select()
            .eq("status", value: LetterStatus.inTransit.rawValue)
            .lte("delivers_at", value: now)
            .execute()
            .value

        // Update each to DELIVERED
        for letter in letters {
            guard let letterId = letter.id else { continue }
            try await supabase
                .from("letters")
                .update(["status": LetterStatus.delivered.rawValue])
                .eq("id", value: letterId)
                .execute()
        }

        return letters
    }

    // MARK: - Send

    func sendLetter(
        senderId: String,
        content: String,
        recipientId: String,
        stampId: Int?,
        songUrl: String?,
        senderLat: Double?,
        senderLon: Double?,
        recipientLat: Double?,
        recipientLon: Double?
    ) async throws -> Letter {
        let now = Date()

        // Calculate distance and delivery time
        var distanceKm: Double = 0
        var deliveryHrs: Double = 0.5

        if let sLat = senderLat, let sLon = senderLon,
           let rLat = recipientLat, let rLon = recipientLon {
            distanceKm = Distance.haversine(lat1: sLat, lon1: sLon, lat2: rLat, lon2: rLon)
            deliveryHrs = min(72, max(0.5, distanceKm / 100))
        }

        let deliversAt = now.addingTimeInterval(deliveryHrs * 3600)

        let letter = Letter(
            senderId: senderId,
            recipientId: recipientId,
            content: content,
            stampId: stampId,
            songUrl: songUrl,
            status: .inTransit,
            isBottle: false,
            distanceKm: distanceKm,
            deliveryHours: deliveryHrs,
            sentAt: now,
            deliversAt: deliversAt,
            createdAt: now
        )

        let inserted: Letter = try await supabase
            .from("letters")
            .insert(letter)
            .select()
            .single()
            .execute()
            .value

        return inserted
    }

    // MARK: - Update

    func markAsRead(letterId: String) async throws {
        let now = ISO8601DateFormatter().string(from: Date())

        try await supabase
            .from("letters")
            .update([
                "status": LetterStatus.read.rawValue,
                "read_at": now
            ])
            .eq("id", value: letterId)
            .execute()
    }

    // MARK: - Realtime

    /// Subscribe to new letters arriving in a user's inbox.
    /// Calls `onNewLetter` whenever a new row is inserted with matching recipient_id.
    func subscribeToInbox(userId: String, onNewLetter: @escaping @Sendable (Letter) -> Void) {
        // Remove existing subscription if any
        if let existing = inboxChannel {
            supabase.realtime.remove(existing)
        }

        let channel = supabase.realtime.channel("inbox-\(userId)")

        channel.on("postgres_changes", filter: ChannelFilter(
            event: "INSERT",
            schema: "public",
            table: "letters",
            filter: "recipient_id=eq.\(userId)"
        )) { message in
            guard let payload = message.payload["record"] as? [String: Any],
                  let data = try? JSONSerialization.data(withJSONObject: payload),
                  let letter = try? JSONDecoder().decode(Letter.self, from: data) else {
                return
            }
            onNewLetter(letter)
        }

        channel.subscribe()
        inboxChannel = channel
    }

    /// Unsubscribe from inbox updates
    func unsubscribeFromInbox() {
        if let channel = inboxChannel {
            supabase.realtime.remove(channel)
            inboxChannel = nil
        }
    }
}
