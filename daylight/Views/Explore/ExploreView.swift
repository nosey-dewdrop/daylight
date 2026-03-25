import SwiftUI

struct ExploreView: View {
    @Environment(AuthService.self) private var authService
    @Environment(UserService.self) private var userService
    @State private var selectedCountryFilter: String?
    @State private var selectedLanguageFilter: String?
    @State private var selectedInterestFilter: String?
    @State private var showFilters = false
    @State private var showCompose = false
    @State private var selectedProfile: Profile?
    @State private var showBottleMail = false

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // World map header area
                        worldMapHeader

                        // Bottle Mail button
                        bottleMailButton

                        // Filters
                        filtersSection

                        // Search results
                        if userService.isLoading {
                            ProgressView()
                                .tint(DaylightTheme.rose)
                                .padding(.top, 40)
                        } else if userService.searchResults.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundColor(DaylightTheme.blue)

                                Text("Search for pen pals")
                                    .font(DaylightTheme.headlineFont)
                                    .foregroundColor(DaylightTheme.text)

                                Text("Use filters or browse to find people from around the world")
                                    .font(DaylightTheme.letterFont)
                                    .foregroundColor(DaylightTheme.textSub)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 40)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(userService.searchResults) { profile in
                                    penPalCard(profile: profile)
                                        .onTapGesture {
                                            selectedProfile = profile
                                        }
                                }
                            }
                            .padding(.horizontal, DaylightTheme.padding)
                        }

                        Spacer().frame(height: 20)
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Explore")
                        .font(DaylightTheme.titleFont)
                        .foregroundColor(DaylightTheme.text)
                }
            }
            .sheet(item: $selectedProfile) { profile in
                PenPalProfileSheet(profile: profile)
            }
            .sheet(isPresented: $showBottleMail) {
                ComposeView(isBottleMail: true)
            }
            .task {
                guard let userId = authService.currentUser?.id else { return }
                await userService.searchPenPals(excludeUserId: userId)
            }
        }
    }

    private var worldMapHeader: some View {
        ZStack {
            // Decorative world map background
            RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [DaylightTheme.rose.opacity(0.1), DaylightTheme.blue.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 8) {
                Image(systemName: "globe.americas.fill")
                    .font(.system(size: 50))
                    .foregroundColor(DaylightTheme.rose.opacity(0.4))

                Text("Discover pen pals worldwide")
                    .font(DaylightTheme.headlineFont)
                    .foregroundColor(DaylightTheme.text)

                Text("\(userService.searchResults.count) people found")
                    .font(DaylightTheme.captionFont)
                    .foregroundColor(DaylightTheme.textSub)
            }
            .padding(.vertical, 24)
        }
        .frame(height: 150)
        .padding(.horizontal, DaylightTheme.padding)
    }

    private var bottleMailButton: some View {
        Button(action: { showBottleMail = true }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(DaylightTheme.rose.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "drop.fill")
                        .font(.system(size: 20))
                        .foregroundColor(DaylightTheme.rose)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Bottle Mail")
                        .font(DaylightTheme.headlineFont)
                        .foregroundColor(DaylightTheme.text)
                    Text("Send a letter to a random stranger")
                        .font(DaylightTheme.captionFont)
                        .foregroundColor(DaylightTheme.textSub)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(DaylightTheme.textSub.opacity(0.5))
            }
            .padding(14)
            .parchmentCard()
        }
        .buttonStyle(.plain)
        .padding(.horizontal, DaylightTheme.padding)
    }

    private var filtersSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Filters")
                    .font(DaylightTheme.headlineFont)
                    .foregroundColor(DaylightTheme.text)

                Spacer()

                Button(action: {
                    withAnimation { showFilters.toggle() }
                }) {
                    Image(systemName: showFilters ? "chevron.up" : "chevron.down")
                        .foregroundColor(DaylightTheme.rose)
                }
            }

            if showFilters {
                VStack(spacing: 12) {
                    // Country filter
                    Menu {
                        Button("All Countries") { selectedCountryFilter = nil; search() }
                        ForEach(Countries.all) { country in
                            Button("\(country.flag) \(country.name)") {
                                selectedCountryFilter = country.name
                                search()
                            }
                        }
                    } label: {
                        filterChip(title: "Country", value: selectedCountryFilter)
                    }

                    // Language filter
                    Menu {
                        Button("All Languages") { selectedLanguageFilter = nil; search() }
                        ForEach(Countries.languages, id: \.self) { language in
                            Button(language) {
                                selectedLanguageFilter = language
                                search()
                            }
                        }
                    } label: {
                        filterChip(title: "Language", value: selectedLanguageFilter)
                    }

                    // Interest filter
                    Menu {
                        Button("All Interests") { selectedInterestFilter = nil; search() }
                        ForEach(userService.allInterests) { interest in
                            Button(interest.name) {
                                selectedInterestFilter = interest.name
                                search()
                            }
                        }
                    } label: {
                        filterChip(title: "Interest", value: selectedInterestFilter)
                    }
                }
            }

            // Active filter chips
            if selectedCountryFilter != nil || selectedLanguageFilter != nil || selectedInterestFilter != nil {
                HStack(spacing: 6) {
                    if let country = selectedCountryFilter {
                        activeFilterChip(text: country) {
                            selectedCountryFilter = nil
                            search()
                        }
                    }
                    if let lang = selectedLanguageFilter {
                        activeFilterChip(text: lang) {
                            selectedLanguageFilter = nil
                            search()
                        }
                    }
                    if let interest = selectedInterestFilter {
                        activeFilterChip(text: interest) {
                            selectedInterestFilter = nil
                            search()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, DaylightTheme.padding)
    }

    private func filterChip(title: String, value: String?) -> some View {
        HStack {
            Text(title)
                .font(DaylightTheme.captionFont)
                .foregroundColor(DaylightTheme.textSub)
            Spacer()
            Text(value ?? "All")
                .font(DaylightTheme.bodyFont)
                .foregroundColor(DaylightTheme.rose)
            Image(systemName: "chevron.down")
                .font(.system(size: 10))
                .foregroundColor(DaylightTheme.rose)
        }
        .padding(10)
        .background(Color.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.smallCornerRadius))
    }

    private func activeFilterChip(text: String, onRemove: @escaping () -> Void) -> some View {
        HStack(spacing: 4) {
            Text(text)
                .font(DaylightTheme.captionFont)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 12))
            }
        }
        .foregroundColor(DaylightTheme.rose)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(DaylightTheme.blue.opacity(0.2))
        .clipShape(Capsule())
    }

    private func penPalCard(profile: Profile) -> some View {
        HStack(spacing: 14) {
            AvatarView(config: profile.avatarConfig ?? .default, size: 50)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(profile.displayName ?? "Unknown")
                        .font(DaylightTheme.headlineFont)
                        .foregroundColor(DaylightTheme.text)

                    if let age = profile.age {
                        Text("\(age)")
                            .font(DaylightTheme.captionFont)
                            .foregroundColor(DaylightTheme.textSub)
                    }
                }

                HStack(spacing: 6) {
                    if let country = profile.country,
                       let info = Countries.find(byName: country) {
                        Text("\(info.flag) \(country)")
                            .font(DaylightTheme.captionFont)
                            .foregroundColor(DaylightTheme.textSub)
                    }

                    if let mbti = profile.mbti {
                        Text(mbti)
                            .font(.system(size: 10, design: .serif))
                            .foregroundColor(DaylightTheme.rose)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(DaylightTheme.blue.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }

                if let interests = profile.interests?.prefix(3), !interests.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(Array(interests), id: \.self) { interest in
                            Text(interest)
                                .font(.system(size: 10, design: .serif))
                                .foregroundColor(DaylightTheme.textSub)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(DaylightTheme.peach.opacity(0.5))
                                .clipShape(Capsule())
                        }
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(DaylightTheme.textSub.opacity(0.5))
        }
        .padding(14)
        .parchmentCard()
    }

    private func search() {
        guard let userId = authService.currentUser?.id else { return }
        Task {
            await userService.searchPenPals(
                excludeUserId: userId,
                country: selectedCountryFilter,
                language: selectedLanguageFilter,
                interest: selectedInterestFilter
            )
        }
    }
}

// MARK: - Pen Pal Profile Sheet

struct PenPalProfileSheet: View {
    let profile: Profile
    @Environment(AuthService.self) private var authService
    @Environment(UserService.self) private var userService
    @Environment(\.dismiss) private var dismiss
    @State private var showCompose = false
    @State private var isSendingRequest = false

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        AvatarView(config: profile.avatarConfig ?? .default, size: 100)
                            .padding(.top, 20)

                        Text(profile.displayName ?? "Unknown")
                            .font(DaylightTheme.titleFont)
                            .foregroundColor(DaylightTheme.text)

                        HStack(spacing: 16) {
                            if let country = profile.country,
                               let info = Countries.find(byName: country) {
                                Label("\(info.flag) \(country)", systemImage: "mappin")
                                    .font(DaylightTheme.captionFont)
                                    .foregroundColor(DaylightTheme.textSub)
                            }
                            if let age = profile.age {
                                Label("\(age)", systemImage: "person")
                                    .font(DaylightTheme.captionFont)
                                    .foregroundColor(DaylightTheme.textSub)
                            }
                        }

                        if let bio = profile.bio, !bio.isEmpty {
                            Text(bio)
                                .font(DaylightTheme.letterFont)
                                .foregroundColor(DaylightTheme.inkBlack.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }

                        // Details
                        VStack(spacing: 12) {
                            if let languages = profile.languages, !languages.isEmpty {
                                detailRow(icon: "text.bubble", title: "Languages", value: languages.joined(separator: ", "))
                            }
                            if let mbti = profile.mbti {
                                detailRow(icon: "brain", title: "MBTI", value: mbti)
                            }
                            if let zodiac = profile.zodiac {
                                detailRow(icon: "sparkles", title: "Zodiac", value: zodiac)
                            }
                        }
                        .padding(.horizontal, DaylightTheme.padding)

                        if let interests = profile.interests, !interests.isEmpty {
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

                        // Action buttons
                        VStack(spacing: 12) {
                            Button(action: { showCompose = true }) {
                                Label("Write a Letter", systemImage: "pencil.line")
                                    .daylightButton()
                            }

                            Button(action: sendFriendRequest) {
                                Group {
                                    if isSendingRequest {
                                        ProgressView().tint(DaylightTheme.rose)
                                    } else {
                                        Label("Add as Pen Pal", systemImage: "person.badge.plus")
                                    }
                                }
                                .daylightButton(isPrimary: false)
                            }
                            .disabled(isSendingRequest)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 12)

                        Spacer().frame(height: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(DaylightTheme.rose)
                }
            }
            .sheet(isPresented: $showCompose) {
                ComposeView(recipientId: profile.id, recipientName: profile.displayName)
            }
        }
    }

    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(DaylightTheme.rose)
                .frame(width: 24)
            Text(title)
                .font(DaylightTheme.captionFont)
                .foregroundColor(DaylightTheme.textSub)
            Spacer()
            Text(value)
                .font(DaylightTheme.bodyFont)
                .foregroundColor(DaylightTheme.text)
        }
        .padding(12)
        .background(Color.white.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.smallCornerRadius))
    }

    private func sendFriendRequest() {
        guard let userId = authService.currentUser?.id else { return }
        isSendingRequest = true
        Task {
            do {
                try await userService.sendFriendRequest(userId: userId, friendId: profile.id)
            } catch {
                // Friend request failed — user can retry
            }
            isSendingRequest = false
        }
    }
}
