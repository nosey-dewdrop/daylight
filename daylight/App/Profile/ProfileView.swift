import SwiftUI

struct ProfileView: View {
    @Environment(AuthService.self) private var auth

    @State private var sentCount = 0
    @State private var receivedCount = 0
    @State private var inTransitCount = 0
    @State private var showAvatarPicker = false
    @State private var showSettings = false

    private let letterService = LetterService()

    private var user: AppUser {
        auth.currentUser ?? .empty
    }

    private var level: LevelInfo {
        Levels.getInfo(xp: user.xp)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Top bar
                        HStack {
                            Spacer()
                            Button {
                                showSettings = true
                            } label: {
                                Image(systemName: "gearshape")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Theme.tx3)
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                        .padding(.top, 4)

                        // Avatar card
                        VStack(spacing: 0) {
                            // Photo area
                            Button {
                                showAvatarPicker = true
                            } label: {
                                ZStack {
                                    AvatarCircleView(config: user.avatarConfig ?? .default, size: 100)

                                    // Edit badge
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(Theme.bg3)
                                                    .frame(width: 24, height: 24)
                                                Image(systemName: "pencil")
                                                    .font(.system(size: 10))
                                                    .foregroundStyle(Theme.txt)
                                            }
                                        }
                                    }
                                    .frame(width: 100, height: 100)
                                }
                            }
                            .padding(.top, 12)
                            .padding(.bottom, 10)

                            // Name
                            Text(user.displayName ?? "friend")
                                .font(Theme.typeFont(size: 18))
                                .foregroundStyle(Theme.txt)
                                .tracking(3)

                            if let country = user.country {
                                Text(country.capitalized)
                                    .font(Theme.typeFont(size: 10))
                                    .foregroundStyle(Theme.tx4)
                                    .tracking(1)
                                    .padding(.top, 2)
                            }
                        }

                        // Level bar
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

                        // Stats
                        HStack(spacing: 0) {
                            StatItem(value: "\(sentCount)", label: "sent")
                            StatItem(value: "\(receivedCount)", label: "received")
                            StatItem(value: "\(inTransitCount)", label: "in transit")
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
                        if user.mbti != nil || user.zodiac != nil || !user.languages.isEmpty {
                            ProfileSection(title: "ABOUT") {
                                VStack(spacing: 0) {
                                    if let mbti = user.mbti {
                                        ProfileRow(icon: "*", label: "mbti", value: mbti.lowercased())
                                    }
                                    if let zodiac = user.zodiac {
                                        ProfileRow(icon: "~", label: "zodiac", value: zodiac)
                                    }
                                    if !user.languages.isEmpty {
                                        ProfileRow(icon: "<>", label: "languages", value: user.languages.joined(separator: ", "))
                                    }
                                }
                            }
                        }

                        // Currently
                        if user.currentBook != nil || user.lastSong != nil || user.lifeMotto != nil {
                            ProfileSection(title: "CURRENTLY") {
                                VStack(spacing: 0) {
                                    if let book = user.currentBook {
                                        ProfileRow(icon: "B", label: "reading", value: book)
                                    }
                                    if let song = user.lastSong {
                                        ProfileRow(icon: "M", label: "listening", value: song)
                                    }
                                    if let motto = user.lifeMotto {
                                        ProfileRow(icon: "Q", label: "motto", value: motto)
                                    }
                                }
                            }
                        }

                        // Interests
                        if !user.interests.isEmpty {
                            ProfileSection(title: "INTERESTS") {
                                FlowLayout {
                                    ForEach(user.interests, id: \.self) { interest in
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
                        }
                    }
                    .padding(.bottom, 80)
                }
            }
        }
        .sheet(isPresented: $showAvatarPicker) {
            AvatarPickerView()
                .environment(auth)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environment(auth)
        }
        .task {
            await loadStats()
        }
    }

    private func loadStats() async {
        guard let userId = auth.currentUser?.id else { return }
        do {
            async let inbox = letterService.fetchInbox(userId: userId)
            async let sent = letterService.fetchSent(userId: userId)

            let (inboxLetters, sentLetters) = try await (inbox, sent)

            await MainActor.run {
                sentCount = sentLetters.count
                receivedCount = inboxLetters.count
                inTransitCount = sentLetters.filter { $0.status == .inTransit }.count
                    + inboxLetters.filter { $0.status == .inTransit }.count
            }
        } catch {
            // Stats will show 0
        }
    }
}
