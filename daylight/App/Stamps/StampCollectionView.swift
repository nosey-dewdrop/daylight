import SwiftUI

struct StampCollectionView: View {
    @Environment(AuthService.self) private var auth

    @State private var allStamps: [Stamp] = []
    @State private var unlockedStampIds: Set<Int> = []
    @State private var isLoading = true
    @State private var selectedCategory: StampCategory? = nil
    @State private var selectedStamp: Stamp?
    @State private var showDetail = false

    private let stampService = StampService()

    private var filteredStamps: [Stamp] {
        if let cat = selectedCategory {
            return allStamps.filter { $0.category == cat }
        }
        return allStamps
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 2) {
                        Text("stamps")
                            .font(Theme.typeFont(size: 20))
                            .foregroundStyle(Theme.txt)
                            .tracking(4)
                        Text("your collection")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .tracking(3)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                    // Category filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            categoryButton(title: "all", category: nil)
                            ForEach(StampCategory.allCases, id: \.self) { cat in
                                categoryButton(title: cat.label.lowercased(), category: cat)
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                    }
                    .padding(.bottom, 12)

                    // Unlocked count
                    let unlockedCount = allStamps.filter { unlockedStampIds.contains($0.id) }.count
                    HStack {
                        Text("\(unlockedCount) / \(allStamps.count) collected")
                            .font(Theme.typeFont(size: 10))
                            .foregroundStyle(Theme.tx3)
                        Spacer()
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.bottom, 8)

                    if isLoading {
                        Spacer()
                        ProgressView()
                            .tint(Theme.lilac)
                        Spacer()
                    } else if allStamps.isEmpty {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "star")
                                .font(.system(size: 32))
                                .foregroundStyle(Theme.tx4)
                            Text("no stamps available")
                                .font(Theme.typeFont(size: 14))
                                .foregroundStyle(Theme.tx3)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 16) {
                                ForEach(filteredStamps) { stamp in
                                    let isUnlocked = unlockedStampIds.contains(stamp.id)
                                    Button {
                                        selectedStamp = stamp
                                        showDetail = true
                                    } label: {
                                        StampGridItem(stamp: stamp, isUnlocked: isUnlocked)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, Theme.padding)
                            .padding(.bottom, 80)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showDetail) {
            if let stamp = selectedStamp {
                StampDetailSheet(
                    stamp: stamp,
                    isUnlocked: unlockedStampIds.contains(stamp.id)
                )
            }
        }
        .task {
            await loadStamps()
        }
    }

    private func categoryButton(title: String, category: StampCategory?) -> some View {
        let isSelected = selectedCategory == category
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedCategory = category
            }
        } label: {
            Text(title)
                .font(Theme.typeFont(size: 10))
                .foregroundStyle(isSelected ? Theme.bg : Theme.tx2)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(isSelected ? Theme.lilac : Theme.bg1)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? Theme.lilac : Theme.brd, lineWidth: 0.5)
                )
        }
        .buttonStyle(.plain)
    }

    private func loadStamps() async {
        guard let userId = auth.currentUser?.id else {
            isLoading = false
            return
        }
        do {
            async let fetchAll = stampService.fetchAllStamps()
            async let fetchUser = stampService.fetchUserStamps(userId: userId)

            let (all, user) = try await (fetchAll, fetchUser)

            await MainActor.run {
                allStamps = all
                unlockedStampIds = Set(user.map(\.id))
                isLoading = false
            }
        } catch {
            isLoading = false
        }
    }
}

// MARK: - Stamp Grid Item

struct StampGridItem: View {
    let stamp: Stamp
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                StampShape()
                    .fill(isUnlocked ? Color(hex: "F8F5EE") : Color(hex: "E0E0E0"))
                    .frame(width: 72, height: 88)
                StampShape()
                    .strokeBorder(isUnlocked ? Theme.brd.opacity(0.3) : Theme.brd.opacity(0.2), lineWidth: 0.5)
                    .frame(width: 72, height: 88)

                if isUnlocked {
                    Image(stamp.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                } else {
                    VStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.tx4)
                        Text("\(stamp.xpRequired) xp")
                            .font(Theme.typeFont(size: 7))
                            .foregroundStyle(Theme.tx4)
                    }
                }
            }
            .shadow(color: .black.opacity(isUnlocked ? 0.08 : 0.03), radius: 4, y: 2)

            Text(stamp.name)
                .font(Theme.typeFont(size: 9))
                .foregroundStyle(isUnlocked ? Theme.txt : Theme.tx4)
                .lineLimit(1)
        }
    }
}

// MARK: - Stamp Detail Sheet

struct StampDetailSheet: View {
    let stamp: Stamp
    let isUnlocked: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 20) {
                // Handle
                Capsule()
                    .fill(Theme.brd)
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)

                // Stamp large
                ZStack {
                    StampShape()
                        .fill(isUnlocked ? Color(hex: "F8F5EE") : Color(hex: "E0E0E0"))
                        .frame(width: 140, height: 170)
                    StampShape()
                        .strokeBorder(Theme.brd.opacity(0.3), lineWidth: 1)
                        .frame(width: 140, height: 170)

                    if isUnlocked {
                        Image(stamp.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(Theme.tx4)
                        }
                    }
                }
                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)

                VStack(spacing: 6) {
                    Text(stamp.name)
                        .font(Theme.typeFont(size: 18))
                        .foregroundStyle(Theme.txt)
                        .tracking(2)

                    Text(stamp.category.label.lowercased())
                        .font(Theme.typeFont(size: 10))
                        .foregroundStyle(Theme.tx3)

                    if isUnlocked {
                        Text("unlocked")
                            .font(Theme.typeFont(size: 10))
                            .foregroundStyle(Theme.deliveredColor)
                            .padding(.top, 4)
                    } else {
                        Text("requires \(stamp.xpRequired) xp to unlock")
                            .font(Theme.typeFont(size: 10))
                            .foregroundStyle(Theme.tx4)
                            .padding(.top, 4)
                    }

                    if stamp.isPremium {
                        Text("premium")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.gold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Theme.gold.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }

                Spacer()
            }
        }
        .presentationDetents([.medium])
    }
}
