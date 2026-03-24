import SwiftUI

struct ExploreView: View {
    @Environment(AuthService.self) private var auth

    @State private var penPals: [AppUser] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedLanguageFilter: String?
    @State private var selectedCountryFilter: String?
    @State private var composeRecipient: AppUser?
    @State private var showCompose = false

    private let userService = UserService()

    private var filteredPenPals: [AppUser] {
        var result = penPals
        if let lang = selectedLanguageFilter {
            result = result.filter { $0.languages.contains(lang) }
        }
        if let country = selectedCountryFilter {
            result = result.filter { $0.country == country }
        }
        return result
    }

    private var availableLanguages: [String] {
        let all = penPals.flatMap { $0.languages }
        return Array(Set(all)).sorted()
    }

    private var availableCountries: [String] {
        let all = penPals.compactMap { $0.country }
        return Array(Set(all)).sorted()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 2) {
                        Text("explore")
                            .font(Theme.typeFont(size: 20))
                            .foregroundStyle(Theme.txt)
                            .tracking(4)
                        Text("find new pen pals")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .tracking(3)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                    // Filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            // Language filter
                            Menu {
                                Button("all languages") {
                                    selectedLanguageFilter = nil
                                }
                                ForEach(availableLanguages, id: \.self) { lang in
                                    Button(lang) {
                                        selectedLanguageFilter = lang
                                    }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "globe")
                                        .font(.system(size: 10))
                                    Text(selectedLanguageFilter ?? "language")
                                        .font(Theme.typeFont(size: 10))
                                }
                                .foregroundStyle(selectedLanguageFilter != nil ? Theme.bg : Theme.tx2)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedLanguageFilter != nil ? Theme.lilac : Theme.bg1)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(selectedLanguageFilter != nil ? Theme.lilac : Theme.brd, lineWidth: 0.5)
                                )
                            }

                            // Country filter
                            Menu {
                                Button("all countries") {
                                    selectedCountryFilter = nil
                                }
                                ForEach(availableCountries, id: \.self) { country in
                                    Button(country.capitalized) {
                                        selectedCountryFilter = country
                                    }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "mappin")
                                        .font(.system(size: 10))
                                    Text(selectedCountryFilter?.capitalized ?? "country")
                                        .font(Theme.typeFont(size: 10))
                                }
                                .foregroundStyle(selectedCountryFilter != nil ? Theme.bg : Theme.tx2)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedCountryFilter != nil ? Theme.lilac : Theme.bg1)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(selectedCountryFilter != nil ? Theme.lilac : Theme.brd, lineWidth: 0.5)
                                )
                            }

                            // Clear filters
                            if selectedLanguageFilter != nil || selectedCountryFilter != nil {
                                Button {
                                    selectedLanguageFilter = nil
                                    selectedCountryFilter = nil
                                } label: {
                                    Text("clear")
                                        .font(Theme.typeFont(size: 9))
                                        .foregroundStyle(Theme.pink)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                }
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                    }
                    .padding(.bottom, 8)

                    // Content
                    if isLoading {
                        Spacer()
                        ProgressView()
                            .tint(Theme.lilac)
                        Spacer()
                    } else if filteredPenPals.isEmpty {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "globe")
                                .font(.system(size: 32))
                                .foregroundStyle(Theme.tx4)
                            Text("no pen pals found")
                                .font(Theme.typeFont(size: 14))
                                .foregroundStyle(Theme.tx3)
                            Text("try different filters")
                                .font(Theme.typeFont(size: 10))
                                .foregroundStyle(Theme.tx4)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredPenPals) { penPal in
                                    PenPalCard(
                                        penPal: penPal,
                                        sharedInterests: sharedInterests(with: penPal),
                                        onSendLetter: {
                                            composeRecipient = penPal
                                            showCompose = true
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, Theme.padding)
                            .padding(.top, 4)
                            .padding(.bottom, 80)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showCompose) {
            if let recipient = composeRecipient {
                ComposeView(recipientId: recipient.id, recipientName: recipient.displayName ?? "pen pal")
                    .environment(auth)
            }
        }
        .task {
            await loadPenPals()
        }
        .refreshable {
            await loadPenPals()
        }
    }

    private func sharedInterests(with penPal: AppUser) -> [String] {
        let myInterests = Set(auth.currentUser?.interests ?? [])
        let theirInterests = Set(penPal.interests)
        return Array(myInterests.intersection(theirInterests))
    }

    private func loadPenPals() async {
        guard let userId = auth.currentUser?.id else { return }
        isLoading = penPals.isEmpty

        do {
            penPals = try await userService.searchPenPals(
                interests: auth.currentUser?.interests ?? [],
                languages: auth.currentUser?.languages ?? [],
                excludeIds: [userId]
            )
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

// MARK: - Pen Pal Card

struct PenPalCard: View {
    let penPal: AppUser
    let sharedInterests: [String]
    let onSendLetter: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                AvatarCircleView(config: penPal.avatarConfig ?? .default, size: 50)

                VStack(alignment: .leading, spacing: 3) {
                    Text(penPal.displayName ?? "pen pal")
                        .font(Theme.typeFont(size: 14))
                        .foregroundStyle(Theme.txt)

                    if let country = penPal.country {
                        Text(country.capitalized)
                            .font(Theme.typeFont(size: 10))
                            .foregroundStyle(Theme.tx3)
                    }

                    if !penPal.languages.isEmpty {
                        Text(penPal.languages.joined(separator: ", "))
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                    }
                }

                Spacer()

                Button {
                    onSendLetter()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "envelope")
                            .font(.system(size: 10))
                        Text("write")
                            .font(Theme.typeFont(size: 10))
                    }
                    .foregroundStyle(Theme.bg)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Theme.lilac)
                    .clipShape(Capsule())
                }
            }

            // Shared interests
            if !sharedInterests.isEmpty {
                FlowLayout(spacing: 4) {
                    ForEach(sharedInterests, id: \.self) { interest in
                        Text(interest)
                            .font(Theme.typeFont(size: 8))
                            .foregroundStyle(Theme.lilac)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Theme.lilac.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(14)
        .background(Theme.bg1)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .strokeBorder(Theme.brd, lineWidth: 0.5)
        )
    }
}
