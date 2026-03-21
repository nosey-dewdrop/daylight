import SwiftUI

struct ProfileView: View {
    private let level = Levels.getInfo(xp: 350)
    @State private var showAvatarPicker = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Passport-style avatar card
                        VStack(spacing: 0) {
                            // Photo area
                            Button {
                                showAvatarPicker = true
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Theme.bg1)
                                        .frame(width: 90, height: 110)
                                    RoundedRectangle(cornerRadius: 4)
                                        .strokeBorder(Theme.brd, style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                                        .frame(width: 90, height: 110)
                                    Text("🌸")
                                        .font(.system(size: 40))
                                    // Edit badge
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(Theme.bg3)
                                                    .frame(width: 22, height: 22)
                                                Image(systemName: "pencil")
                                                    .font(.system(size: 9))
                                                    .foregroundStyle(Theme.txt)
                                            }
                                        }
                                    }
                                    .frame(width: 90, height: 110)
                                }
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 10)

                            // Name — typewriter
                            Text("damla")
                                .font(Theme.typeFont(size: 18))
                                .foregroundStyle(Theme.txt)
                                .tracking(3)

                            Text("istanbul, türkiye")
                                .font(Theme.typeFont(size: 10))
                                .foregroundStyle(Theme.tx4)
                                .tracking(1)
                                .padding(.top, 2)
                        }

                        // Level bar — typewriter
                        VStack(spacing: 6) {
                            HStack {
                                Text("lv.\(level.level) \(level.name)")
                                    .font(Theme.typeFont(size: 10))
                                    .foregroundStyle(Theme.lilac)
                                Spacer()
                                Text("\(level.xp) / \(level.xpNext) xp")
                                    .font(Theme.typeFont(size: 9))
                                    .foregroundStyle(Theme.tx3)
                            }

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Theme.bg3)
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Theme.lilac)
                                        .frame(width: geo.size.width * level.progress)
                                }
                            }
                            .frame(height: 5)
                        }
                        .padding(.horizontal, Theme.padding)

                        // Stats — typewriter
                        HStack(spacing: 0) {
                            StatItem(value: "12", label: "sent")
                            StatItem(value: "8", label: "received")
                            StatItem(value: "3", label: "in transit")
                        }
                        .padding(.vertical, 12)
                        .background(Theme.bg1)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Theme.brd, lineWidth: 0.5)
                        )
                        .padding(.horizontal, Theme.padding)

                        // About
                        ProfileSection(title: "ABOUT") {
                            ProfileRow(icon: "✦", label: "mbti", value: "infp")
                            ProfileRow(icon: "☽", label: "zodiac", value: "pisces")
                            ProfileRow(icon: "♡", label: "languages", value: "tr, en, fr")
                        }

                        // Currently
                        ProfileSection(title: "CURRENTLY") {
                            ProfileRow(icon: "📖", label: "reading", value: "norwegian wood — murakami")
                            ProfileRow(icon: "🎵", label: "listening", value: "mitski — nobody")
                            ProfileRow(icon: "💭", label: "motto", value: "slow things are beautiful things")
                        }

                        // Interests
                        ProfileSection(title: "INTERESTS") {
                            FlowLayout {
                                ForEach(["poetry", "astronomy", "film", "letters", "tea", "piano", "art history"], id: \.self) { interest in
                                    Text(interest)
                                        .font(Theme.typeFont(size: 10))
                                        .foregroundStyle(Theme.txt)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Theme.bg2)
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Theme.brd, lineWidth: 0.5)
                                        )
                                }
                            }
                        }

                        // Coming soon sections
                        ProfileSection(title: "MY ROOM") {
                            VStack(spacing: 8) {
                                Text("🏠")
                                    .font(.system(size: 28))
                                Text("coming soon")
                                    .font(Theme.typeFont(size: 10))
                                    .foregroundStyle(Theme.tx4)
                                Text("decorate your room & invite friends")
                                    .font(Theme.typeFont(size: 8))
                                    .foregroundStyle(Theme.tx4)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }

                        ProfileSection(title: "STAMP COLLECTION") {
                            VStack(spacing: 8) {
                                Text("💌")
                                    .font(.system(size: 28))
                                Text("coming soon")
                                    .font(Theme.typeFont(size: 10))
                                    .foregroundStyle(Theme.tx4)
                                Text("collect & unlock stamps with xp")
                                    .font(Theme.typeFont(size: 8))
                                    .foregroundStyle(Theme.tx4)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.bottom, 80)
                }
            }
        }
        .sheet(isPresented: $showAvatarPicker) {
            AvatarPickerView()
        }
    }
}

// MARK: - Components

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

struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, origin) in result.origins.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (origins: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var origins: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            origins.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (origins, CGSize(width: maxWidth, height: y + rowHeight))
    }
}

#Preview {
    ProfileView()
        .preferredColorScheme(.light)
}
