import SwiftUI

struct EnvelopeCard: View {
    let letter: Letter
    var senderName: String = "Unknown"
    var senderAvatar: AvatarConfig?
    var stampName: String?
    var onTap: (() -> Void)?

    @State private var isPressed = false

    var body: some View {
        Button(action: { onTap?() }) {
            ZStack {
                // Envelope body
                envelopeBody

                // Content overlay
                VStack(alignment: .leading, spacing: 8) {
                    // Top row: avatar + stamp
                    HStack {
                        // Sender avatar (vesikalik size)
                        AvatarView(config: senderAvatar ?? .default, size: 36)
                            .overlay(
                                Circle()
                                    .stroke(DaylightTheme.warmBrown.opacity(0.3), lineWidth: 1)
                            )

                        VStack(alignment: .leading, spacing: 2) {
                            Text(senderName)
                                .font(DaylightTheme.headlineFont)
                                .foregroundColor(DaylightTheme.darkBrown)

                            if let country = letter.sender?.country,
                               let info = Countries.find(byName: country) {
                                Text("\(info.flag) \(country)")
                                    .font(DaylightTheme.captionFont)
                                    .foregroundColor(DaylightTheme.warmBrown)
                            }
                        }

                        Spacer()

                        // Stamp in top-right
                        if let stampName = stampName {
                            VStack {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(DaylightTheme.deepBlue.opacity(0.7))
                                    .frame(width: 36, height: 44)
                                    .overlay(
                                        Text(stampName.prefix(2).uppercased())
                                            .font(.system(size: 10, design: .serif))
                                            .foregroundColor(.white)
                                    )
                                    .overlay(
                                        StampShape(perforationRadius: 1.5, perforationSpacing: 5)
                                            .stroke(Color.white.opacity(0.5), lineWidth: 0.5)
                                    )
                            }
                        }
                    }

                    // Letter preview
                    Text(letter.content.prefix(80) + (letter.content.count > 80 ? "..." : ""))
                        .font(DaylightTheme.letterFont)
                        .foregroundColor(DaylightTheme.inkBlack.opacity(0.7))
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Bottom row: date + distance
                    HStack {
                        if let distance = letter.distanceKm {
                            Label(
                                DistanceCalculator.formatDistance(distance),
                                systemImage: "location.fill"
                            )
                            .font(DaylightTheme.captionFont)
                            .foregroundColor(DaylightTheme.warmBrown.opacity(0.7))
                        }

                        Spacer()

                        if letter.status == .delivered {
                            StatusBadge(status: .delivered)
                        } else if letter.status == .read {
                            StatusBadge(status: .read)
                        }

                        if let date = letter.deliversAt ?? letter.sentAt {
                            Text(date, style: .relative)
                                .font(DaylightTheme.captionFont)
                                .foregroundColor(DaylightTheme.warmBrown.opacity(0.6))
                        }
                    }
                }
                .padding(16)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.97 : 1.0)
    }

    private var envelopeBody: some View {
        ZStack {
            // Main envelope
            RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius)
                .fill(DaylightTheme.parchment)
                .shadow(color: DaylightTheme.warmBrown.opacity(0.15), radius: 6, x: 0, y: 3)

            // Envelope flap (decorative triangle at top)
            VStack {
                envelopeFlap
                Spacer()
            }

            // Parchment texture overlay
            RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [.clear, DaylightTheme.parchmentDark.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Wax seal for delivered letters
            if letter.status == .delivered {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        WaxSeal(size: 28)
                            .padding(8)
                    }
                }
            }

            // Bottle indicator
            if letter.isBottle {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "drop.fill")
                            .font(.system(size: 12))
                            .foregroundColor(DaylightTheme.deepBlue)
                            .padding(6)
                            .background(Circle().fill(DaylightTheme.babyBlue.opacity(0.3)))
                            .padding(8)
                    }
                    Spacer()
                }
            }
        }
        .frame(height: 150)
    }

    private var envelopeFlap: some View {
        GeometryReader { geometry in
            Path { path in
                let w = geometry.size.width
                path.move(to: CGPoint(x: DaylightTheme.cornerRadius, y: 0))
                path.addLine(to: CGPoint(x: w / 2, y: 16))
                path.addLine(to: CGPoint(x: w - DaylightTheme.cornerRadius, y: 0))
            }
            .stroke(DaylightTheme.warmBrown.opacity(0.15), lineWidth: 1)
        }
        .frame(height: 16)
    }
}

#Preview {
    EnvelopeCard(
        letter: Letter(
            id: UUID(),
            senderId: UUID(),
            recipientId: UUID(),
            content: "Hello! This is a sample letter that shows how the envelope card looks with some preview text inside it.",
            stampId: nil,
            status: .delivered,
            isBottle: false,
            distanceKm: 1234,
            deliveryHours: 12,
            sentAt: Date().addingTimeInterval(-3600),
            deliversAt: Date(),
            readAt: nil,
            createdAt: Date()
        ),
        senderName: "Ayumi",
        stampName: "First Letter"
    )
    .padding()
    .background(DaylightTheme.cream)
}
