import SwiftUI

struct LetterDetailView: View {
    let letter: Letter
    @Environment(AuthService.self) private var authService
    @Environment(LetterService.self) private var letterService
    @Environment(\.dismiss) private var dismiss
    @State private var showReply = false
    @State private var hasMarkedRead = false

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // Letter header (like envelope top)
                        letterHeader

                        // Letter body on parchment
                        VStack(alignment: .leading, spacing: 16) {
                            // Greeting
                            if let senderName = letter.sender?.displayName {
                                Text("From \(senderName)")
                                    .font(DaylightTheme.headlineFont)
                                    .foregroundColor(DaylightTheme.rose)
                            }

                            // Distance and travel info
                            if let distance = letter.distanceKm, let hours = letter.deliveryHours {
                                HStack(spacing: 16) {
                                    Label(DistanceCalculator.formatDistance(distance), systemImage: "location.fill")
                                    Label(String(format: "%.0fh travel", hours), systemImage: "clock.fill")
                                }
                                .font(DaylightTheme.captionFont)
                                .foregroundColor(DaylightTheme.textSub)
                            }

                            Divider()
                                .background(DaylightTheme.textSub.opacity(0.3))

                            // Letter content
                            Text(letter.content)
                                .font(DaylightTheme.letterFont)
                                .foregroundColor(DaylightTheme.inkBlack)
                                .lineSpacing(8)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Divider()
                                .background(DaylightTheme.textSub.opacity(0.3))

                            // Footer
                            HStack {
                                if let date = letter.sentAt {
                                    Text("Sent \(date, style: .date)")
                                        .font(DaylightTheme.captionFont)
                                        .foregroundColor(DaylightTheme.textSub)
                                }
                                Spacer()
                                if letter.isBottle {
                                    Label("Bottle Mail", systemImage: "drop.fill")
                                        .font(DaylightTheme.captionFont)
                                        .foregroundColor(DaylightTheme.rose)
                                }
                            }

                            // Wax seal at bottom
                            HStack {
                                Spacer()
                                WaxSeal(size: 50)
                                Spacer()
                            }
                            .padding(.top, 8)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius)
                                .fill(DaylightTheme.parchment)
                                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal, 16)

                        // Reply button
                        if letter.recipientId == authService.currentUser?.id {
                            Button(action: { showReply = true }) {
                                Label("Write Back", systemImage: "arrowshape.turn.up.left.fill")
                                    .daylightButton()
                            }
                            .padding(.horizontal, 40)
                            .padding(.top, 24)
                        }

                        Spacer().frame(height: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(DaylightTheme.rose)
                }
            }
            .sheet(isPresented: $showReply) {
                ComposeView(recipientId: letter.senderId, recipientName: letter.sender?.displayName)
            }
            .task {
                if !hasMarkedRead && letter.status == .delivered {
                    hasMarkedRead = true
                    await letterService.markAsRead(letterId: letter.id)
                }
            }
        }
    }

    private var letterHeader: some View {
        HStack(alignment: .top) {
            // Sender avatar
            VStack(spacing: 4) {
                AvatarView(config: letter.sender?.avatarConfig ?? .default, size: 50)
                    .overlay(Circle().stroke(DaylightTheme.textSub.opacity(0.3), lineWidth: 1))

                Text(letter.sender?.displayName ?? "")
                    .font(DaylightTheme.captionFont)
                    .foregroundColor(DaylightTheme.text)
            }

            Spacer()

            // Stamp
            VStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(DaylightTheme.rose.opacity(0.8))
                    .frame(width: 50, height: 65)
                    .overlay(
                        VStack(spacing: 2) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            if let country = letter.sender?.country {
                                Text(country.prefix(6))
                                    .font(.system(size: 8, design: .serif))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    )
                    .overlay(
                        StampShape(perforationRadius: 2, perforationSpacing: 5)
                            .stroke(Color.white.opacity(0.4), lineWidth: 0.5)
                    )
            }
        }
        .padding(20)
    }
}
