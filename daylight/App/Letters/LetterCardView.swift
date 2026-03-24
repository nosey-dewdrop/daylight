import SwiftUI

struct LetterCardView: View {
    let letter: Letter
    var isInbox: Bool = true

    private var displayName: String {
        if isInbox {
            return letter.sender?.displayName ?? "pen pal"
        } else {
            return letter.recipient?.displayName ?? "pen pal"
        }
    }

    private var avatarConfig: AvatarConfig {
        if isInbox {
            return letter.sender?.avatarConfig ?? .default
        } else {
            return letter.recipient?.avatarConfig ?? .default
        }
    }

    private var timeText: String {
        if letter.status == .inTransit, let deliversAt = letter.deliversAt {
            let formatter = ISO8601DateFormatter()
            return Distance.timeLeft(deliversAt: formatter.string(from: deliversAt))
        } else if let sentAt = letter.sentAt {
            return Distance.formatDate(ISO8601DateFormatter().string(from: sentAt))
        }
        return ""
    }

    var body: some View {
        HStack(spacing: 12) {
            // Avatar -- passport/vesikalik size, top-left
            AvatarView(config: avatarConfig, size: 36, showBackground: true)

            // Letter info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(displayName)
                        .font(Theme.handFont(size: 16))
                        .foregroundStyle(Theme.txt)
                    Spacer()
                    // Stamp -- top-right of the card
                    StampShape()
                        .fill(Color(hex: "F8F5EE"))
                        .frame(width: 28, height: 34)
                        .overlay(
                            StampShape()
                                .strokeBorder(Theme.brd.opacity(0.3), lineWidth: 0.5)
                        )
                        .overlay(
                            Group {
                                if let stampName = letter.stamp?.imageName {
                                    Image(stampName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                } else {
                                    Image(systemName: "star")
                                        .font(.system(size: 10))
                                        .foregroundStyle(Theme.tx4)
                                }
                            }
                        )
                }

                Text(letter.content.prefix(60) + (letter.content.count > 60 ? "..." : ""))
                    .font(Theme.typeFont(size: 10))
                    .foregroundStyle(Theme.tx3)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    StatusBadge(status: letter.status)
                    if letter.status == .inTransit {
                        JourneyDots()
                    }
                    Spacer()
                    Text(timeText)
                        .font(Theme.typeFont(size: 8))
                        .foregroundStyle(Theme.tx4)
                        .italic()
                }
            }
        }
        .padding(12)
        .background(Theme.bg1)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .strokeBorder(Theme.brd, lineWidth: 0.5)
        )
        .overlay(alignment: .topTrailing) {
            // Wax seal for delivered letters
            if letter.status == .delivered {
                WaxSeal()
                    .offset(x: -6, y: -6)
            }
        }
    }
}
