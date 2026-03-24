import SwiftUI

struct ProfileView: View {
    @Environment(AuthService.self) private var authService
    @State private var showAvatarBuilder = false
    @State private var showStampCollection = false
    @State private var showSettings = false

    private var profile: Profile? { authService.currentProfile }

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Avatar and basic info
                        VStack(spacing: 12) {
                            Button(action: { showAvatarBuilder = true }) {
                                ZStack(alignment: .bottomTrailing) {
                                    AvatarView(config: profile?.avatarConfig ?? .default, size: 100)
                                        .overlay(Circle().stroke(DaylightTheme.textSub.opacity(0.2), lineWidth: 2))

                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(DaylightTheme.rose)
                                        .background(Circle().fill(.white))
                                }
                            }

                            Text(profile?.displayName ?? "Your Name")
                                .font(DaylightTheme.titleFont)
                                .foregroundColor(DaylightTheme.text)

                            if let country = profile?.country,
                               let info = Countries.find(byName: country) {
                                Text("\(info.flag) \(country)")
                                    .font(DaylightTheme.bodyFont)
                                    .foregroundColor(DaylightTheme.textSub)
                            }

                            if let bio = profile?.bio, !bio.isEmpty {
                                Text(bio)
                                    .font(DaylightTheme.letterFont)
                                    .foregroundColor(DaylightTheme.inkBlack.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 30)
                            }
                        }
                        .padding(.top, 16)

                        // Level & XP
                        levelCard

                        // Stats
                        statsGrid

                        // Interests
                        if let interests = profile?.interests, !interests.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Interests")
                                    .font(DaylightTheme.headlineFont)
                                    .foregroundColor(DaylightTheme.text)

                                FlowLayout(spacing: 6) {
                                    ForEach(interests, id: \.self) { interest in
                                        InterestChip(text: interest)
                                    }
                                }
                            }
                            .padding(.horizontal, DaylightTheme.padding)
                        }

                        // Quick actions
                        VStack(spacing: 8) {
                            actionButton(icon: "paintpalette", title: "Edit Avatar") {
                                showAvatarBuilder = true
                            }
                            actionButton(icon: "stamp", title: "Stamp Collection") {
                                showStampCollection = true
                            }
                            actionButton(icon: "gearshape", title: "Settings") {
                                showSettings = true
                            }
                        }
                        .padding(.horizontal, DaylightTheme.padding)

                        Spacer().frame(height: 40)
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(DaylightTheme.titleFont)
                        .foregroundColor(DaylightTheme.text)
                }
            }
            .sheet(isPresented: $showAvatarBuilder) {
                AvatarBuilderView()
            }
            .sheet(isPresented: $showStampCollection) {
                StampCollectionView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

    private var levelCard: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Level \(profile?.level ?? 1)")
                    .font(DaylightTheme.headlineFont)
                    .foregroundColor(DaylightTheme.text)

                Spacer()

                Text("\(profile?.xp ?? 0) XP")
                    .font(DaylightTheme.bodyFont)
                    .foregroundColor(DaylightTheme.rose)
            }

            // XP progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(DaylightTheme.blue.opacity(0.3))

                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [DaylightTheme.rose, DaylightTheme.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * LevelSystem.progress(xp: profile?.xp ?? 0))
                }
            }
            .frame(height: 10)

            Text("Next level: \(LevelSystem.xpForLevel((profile?.level ?? 1) + 1)) XP")
                .font(DaylightTheme.captionFont)
                .foregroundColor(DaylightTheme.textSub)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(16)
        .parchmentCard()
        .padding(.horizontal, DaylightTheme.padding)
    }

    private var statsGrid: some View {
        HStack(spacing: 12) {
            statItem(value: "\(profile?.level ?? 1)", label: "Level", icon: "star.fill")
            statItem(value: profile?.mbti ?? "-", label: "MBTI", icon: "brain")
            statItem(value: profile?.zodiac ?? "-", label: "Zodiac", icon: "sparkles")
        }
        .padding(.horizontal, DaylightTheme.padding)
    }

    private func statItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(DaylightTheme.rose)

            Text(value)
                .font(DaylightTheme.headlineFont)
                .foregroundColor(DaylightTheme.text)

            Text(label)
                .font(DaylightTheme.captionFont)
                .foregroundColor(DaylightTheme.textSub)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .parchmentCard()
    }

    private func actionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(DaylightTheme.rose)
                    .frame(width: 24)
                Text(title)
                    .font(DaylightTheme.bodyFont)
                    .foregroundColor(DaylightTheme.text)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(DaylightTheme.textSub.opacity(0.5))
            }
            .padding(14)
            .parchmentCard()
        }
        .buttonStyle(.plain)
    }
}
