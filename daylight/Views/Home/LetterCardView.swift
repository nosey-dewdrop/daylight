import SwiftUI

struct LetterCardView: View {
    let letter: Letter
    var showSender: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if showSender {
                    AvatarView(config: letter.sender?.avatarConfig ?? .default, size: 32)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(letter.sender?.displayName ?? "Unknown")
                            .font(DaylightTheme.headlineFont)
                            .foregroundColor(DaylightTheme.darkBrown)
                        if let country = letter.sender?.country {
                            Text(country)
                                .font(DaylightTheme.captionFont)
                                .foregroundColor(DaylightTheme.warmBrown)
                        }
                    }
                } else {
                    AvatarView(config: letter.recipient?.avatarConfig ?? .default, size: 32)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("To: \(letter.recipient?.displayName ?? "Unknown")")
                            .font(DaylightTheme.headlineFont)
                            .foregroundColor(DaylightTheme.darkBrown)
                    }
                }

                Spacer()

                if letter.isBottle {
                    Image(systemName: "drop.fill")
                        .foregroundColor(DaylightTheme.deepBlue)
                        .font(.system(size: 14))
                }

                if letter.isInTransit {
                    VStack(spacing: 2) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(DaylightTheme.skyBlue)
                        Text(DistanceCalculator.formatCountdown(letter.timeUntilDelivery))
                            .font(.system(size: 10, design: .serif))
                            .foregroundColor(DaylightTheme.deepBlue)
                    }
                }
            }

            Text(letter.content.prefix(100) + (letter.content.count > 100 ? "..." : ""))
                .font(DaylightTheme.letterFont)
                .foregroundColor(DaylightTheme.inkBlack.opacity(0.7))
                .lineLimit(2)

            HStack {
                if let distance = letter.distanceKm {
                    Text(DistanceCalculator.formatDistance(distance))
                        .font(DaylightTheme.captionFont)
                        .foregroundColor(DaylightTheme.warmBrown)
                }
                Spacer()
                if let date = letter.sentAt {
                    Text(date, style: .relative)
                        .font(DaylightTheme.captionFont)
                        .foregroundColor(DaylightTheme.warmBrown.opacity(0.6))
                }
            }
        }
        .padding(14)
        .parchmentCard()
    }
}
