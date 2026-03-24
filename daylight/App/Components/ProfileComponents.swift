import SwiftUI

struct StatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 3) {
            Text(value)
                .font(Theme.typeFont(size: 20))
                .foregroundStyle(Theme.txt)
            Text(label)
                .font(Theme.typeFont(size: 8))
                .foregroundStyle(Theme.tx3)
                .tracking(1)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfileSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Theme.typeFont(size: 9))
                .foregroundStyle(Theme.tx4)
                .tracking(2)

            VStack(spacing: 0) {
                content
            }
            .padding(14)
            .background(Theme.bg1)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Theme.brd, lineWidth: 0.5)
            )
        }
        .padding(.horizontal, Theme.padding)
    }
}

struct ProfileRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 12))
                .frame(width: 18)
            Text(label)
                .font(Theme.typeFont(size: 10))
                .foregroundStyle(Theme.tx3)
                .frame(width: 70, alignment: .leading)
            Text(value)
                .font(Theme.typeFont(size: 10))
                .foregroundStyle(Theme.txt)
        }
        .padding(.vertical, 3)
    }
}
