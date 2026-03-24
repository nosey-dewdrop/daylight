import SwiftUI

enum BadgeStatus {
    case unread
    case delivered
    case read
    case replied
    case inTransit

    var label: String {
        switch self {
        case .unread: return "New"
        case .delivered: return "Delivered"
        case .read: return "Read"
        case .replied: return "Replied"
        case .inTransit: return "In Transit"
        }
    }

    var color: Color {
        switch self {
        case .unread: return DaylightTheme.waxRed
        case .delivered: return DaylightTheme.green
        case .read: return DaylightTheme.textMuted
        case .replied: return DaylightTheme.blue
        case .inTransit: return DaylightTheme.softGold
        }
    }

    var icon: String {
        switch self {
        case .unread: return "circle.fill"
        case .delivered: return "envelope.fill"
        case .read: return "envelope.open.fill"
        case .replied: return "arrowshape.turn.up.left.fill"
        case .inTransit: return "paperplane.fill"
        }
    }
}

struct StatusBadge: View {
    let status: BadgeStatus
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.icon)
                .font(.system(size: compact ? 8 : 10))

            if !compact {
                Text(status.label)
                    .font(.system(size: 10, design: .serif))
            }
        }
        .foregroundColor(status.color)
        .padding(.horizontal, compact ? 4 : 8)
        .padding(.vertical, 3)
        .background(
            Capsule()
                .fill(status.color.opacity(0.12))
        )
    }
}

#Preview {
    VStack(spacing: 10) {
        StatusBadge(status: .unread)
        StatusBadge(status: .delivered)
        StatusBadge(status: .read)
        StatusBadge(status: .replied)
        StatusBadge(status: .inTransit)
        StatusBadge(status: .unread, compact: true)
    }
}
