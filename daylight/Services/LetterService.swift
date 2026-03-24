import Foundation
import Supabase
import Realtime

@Observable
final class LetterService {
    var inboxLetters: [Letter] = []
    var sentLetters: [Letter] = []
    var drafts: [Letter] = []
    var inTransitLetters: [Letter] = []
    var isLoading = false
    var errorMessage: String?

    private let client = SupabaseManager.client
    private var realtimeChannel: RealtimeChannelV2?

    @MainActor
    func fetchInbox(userId: UUID) async {
        isLoading = true
        defer { isLoading = false }
        do {
            // Deliver any letters that should have arrived
            try await client.rpc("deliver_letters").execute()

            let letters: [Letter] = try await client
                .from("letters")
                .select("*, sender:profiles!letters_sender_id_fkey(*)")
                .eq("recipient_id", value: userId.uuidString)
                .in("status", values: ["DELIVERED", "READ"])
                .order("delivers_at", ascending: false)
                .execute()
                .value
            inboxLetters = letters
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func fetchInTransit(userId: UUID) async {
        do {
            let letters: [Letter] = try await client
                .from("letters")
                .select("*, sender:profiles!letters_sender_id_fkey(*)")
                .eq("recipient_id", value: userId.uuidString)
                .eq("status", value: "IN_TRANSIT")
                .order("delivers_at", ascending: true)
                .execute()
                .value
            inTransitLetters = letters
        } catch {
            print("Failed to fetch in-transit: \(error)")
        }
    }

    @MainActor
    func fetchSent(userId: UUID) async {
        do {
            let letters: [Letter] = try await client
                .from("letters")
                .select("*, recipient:profiles!letters_recipient_id_fkey(*)")
                .eq("sender_id", value: userId.uuidString)
                .neq("status", value: "DRAFT")
                .order("sent_at", ascending: false)
                .execute()
                .value
            sentLetters = letters
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func fetchDrafts(userId: UUID) async {
        do {
            let letters: [Letter] = try await client
                .from("letters")
                .select("*, recipient:profiles!letters_recipient_id_fkey(*)")
                .eq("sender_id", value: userId.uuidString)
                .eq("status", value: "DRAFT")
                .order("created_at", ascending: false)
                .execute()
                .value
            drafts = letters
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func sendLetter(
        senderId: UUID,
        recipientId: UUID,
        content: String,
        stampId: UUID?,
        senderLat: Double,
        senderLng: Double,
        recipientLat: Double,
        recipientLng: Double,
        isBottle: Bool = false
    ) async throws {
        let distance = DistanceCalculator.haversine(
            lat1: senderLat, lng1: senderLng,
            lat2: recipientLat, lng2: recipientLng
        )
        let hours = DistanceCalculator.deliveryHours(distanceKm: distance)
        let now = Date()
        let deliverDate = now.addingTimeInterval(hours * 3600)

        let insert = LetterInsert(
            senderId: senderId,
            recipientId: recipientId,
            content: content,
            stampId: stampId,
            status: LetterStatus.inTransit.rawValue,
            isBottle: isBottle,
            distanceKm: distance,
            deliveryHours: hours,
            sentAt: now,
            deliversAt: deliverDate
        )

        try await client
            .from("letters")
            .insert(insert)
            .execute()
    }

    @MainActor
    func saveDraft(senderId: UUID, recipientId: UUID, content: String, stampId: UUID?) async throws {
        struct DraftInsert: Codable {
            let senderId: UUID
            let recipientId: UUID
            let content: String
            let stampId: UUID?
            let status: String
            let isBottle: Bool

            enum CodingKeys: String, CodingKey {
                case senderId = "sender_id"
                case recipientId = "recipient_id"
                case content
                case stampId = "stamp_id"
                case status
                case isBottle = "is_bottle"
            }
        }

        let draft = DraftInsert(
            senderId: senderId,
            recipientId: recipientId,
            content: content,
            stampId: stampId,
            status: "DRAFT",
            isBottle: false
        )

        try await client.from("letters").insert(draft).execute()
    }

    @MainActor
    func markAsRead(letterId: UUID) async {
        do {
            try await client
                .from("letters")
                .update(["status": "READ", "read_at": ISO8601DateFormatter().string(from: Date())])
                .eq("id", value: letterId.uuidString)
                .execute()
        } catch {
            print("Failed to mark as read: \(error)")
        }
    }

    @MainActor
    func deleteDraft(letterId: UUID) async {
        do {
            try await client
                .from("letters")
                .delete()
                .eq("id", value: letterId.uuidString)
                .execute()
        } catch {
            print("Failed to delete draft: \(error)")
        }
    }

    func subscribeToLetters(userId: UUID) async {
        let channel = client.realtimeV2.channel("letters-\(userId.uuidString)")

        let changes = channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: "letters",
            filter: "recipient_id=eq.\(userId.uuidString)"
        )

        await channel.subscribe()
        self.realtimeChannel = channel

        Task {
            for await _ in changes {
                await self.fetchInbox(userId: userId)
                await self.fetchInTransit(userId: userId)
            }
        }
    }

    func unsubscribe() async {
        if let channel = realtimeChannel {
            await client.realtimeV2.removeChannel(channel)
        }
    }
}
