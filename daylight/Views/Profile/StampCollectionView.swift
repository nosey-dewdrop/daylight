import SwiftUI

struct StampCollectionView: View {
    @Environment(AuthService.self) private var authService
    @Environment(StampService.self) private var stampService
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Stats header
                        HStack(spacing: 20) {
                            statCircle(
                                value: "\(stampService.unlockedStampIds.count)",
                                label: "Unlocked",
                                color: DaylightTheme.mutedGreen
                            )
                            statCircle(
                                value: "\(stampService.allStamps.count)",
                                label: "Total",
                                color: DaylightTheme.deepBlue
                            )
                            statCircle(
                                value: "\(authService.currentProfile?.xp ?? 0)",
                                label: "XP",
                                color: DaylightTheme.softGold
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)

                        // Stamps by category (album style)
                        let grouped = stampService.stampsByCategory()
                        ForEach(Array(grouped.keys.sorted()), id: \.self) { category in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(category)
                                        .font(DaylightTheme.headlineFont)
                                        .foregroundColor(DaylightTheme.darkBrown)

                                    Spacer()

                                    let total = grouped[category]?.count ?? 0
                                    let unlocked = grouped[category]?.filter { stampService.isUnlocked($0) || $0.xpRequired == 0 }.count ?? 0
                                    Text("\(unlocked)/\(total)")
                                        .font(DaylightTheme.captionFont)
                                        .foregroundColor(DaylightTheme.warmBrown)
                                }

                                // Album-style grid
                                LazyVGrid(columns: [
                                    GridItem(.adaptive(minimum: 70), spacing: 12)
                                ], spacing: 12) {
                                    ForEach(grouped[category] ?? []) { stamp in
                                        let isUnlocked = stampService.isUnlocked(stamp) || stamp.xpRequired == 0
                                        VStack(spacing: 4) {
                                            StampView(
                                                stamp: stamp,
                                                width: 60,
                                                isUnlocked: isUnlocked
                                            )

                                            if !isUnlocked && stamp.xpRequired > 0 {
                                                Text("\(stamp.xpRequired) XP")
                                                    .font(.system(size: 9, design: .serif))
                                                    .foregroundColor(DaylightTheme.warmBrown)
                                            }
                                        }
                                    }
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius)
                                        .fill(DaylightTheme.parchment.opacity(0.5))
                                )
                            }
                        }

                        Spacer().frame(height: 20)
                    }
                    .padding(.horizontal, DaylightTheme.padding)
                }
            }
            .navigationTitle("Stamp Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(DaylightTheme.deepBlue)
                }
            }
        }
    }

    private func statCircle(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)
                Text(value)
                    .font(DaylightTheme.headlineFont)
                    .foregroundColor(color)
            }
            Text(label)
                .font(DaylightTheme.captionFont)
                .foregroundColor(DaylightTheme.warmBrown)
        }
    }
}
