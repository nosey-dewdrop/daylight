import SwiftUI

struct OnboardingView: View {
    @Environment(AuthService.self) private var auth

    @State private var currentPage = 0
    @State private var displayName = ""
    @State private var age = ""
    @State private var selectedCountry = ""
    @State private var selectedLanguages: Set<String> = []
    @State private var selectedInterests: Set<String> = []
    @State private var avatarConfig = AvatarConfig.default
    @State private var mbti = ""
    @State private var zodiac = ""
    @State private var errorMessage: String?
    @State private var isSaving = false

    private let totalPages = 8

    private let allLanguages = [
        "english", "spanish", "french", "german", "portuguese",
        "italian", "dutch", "russian", "japanese", "korean",
        "chinese", "arabic", "turkish", "hindi", "polish",
        "swedish", "norwegian", "danish", "finnish", "czech",
        "greek", "thai", "vietnamese", "indonesian", "tagalog"
    ]

    private let allInterests = [
        "poetry", "astronomy", "film", "letters", "tea", "piano",
        "art history", "philosophy", "photography", "cooking",
        "travel", "reading", "music", "gaming", "painting",
        "writing", "hiking", "yoga", "gardening", "crafts",
        "science", "languages", "history", "architecture", "fashion",
        "coffee", "anime", "nature", "psychology", "mythology"
    ]

    private let mbtiTypes = [
        "INTJ", "INTP", "ENTJ", "ENTP",
        "INFJ", "INFP", "ENFJ", "ENFP",
        "ISTJ", "ISFJ", "ESTJ", "ESFJ",
        "ISTP", "ISFP", "ESTP", "ESFP"
    ]

    private let zodiacSigns = [
        "aries", "taurus", "gemini", "cancer",
        "leo", "virgo", "libra", "scorpio",
        "sagittarius", "capricorn", "aquarius", "pisces"
    ]

    private let backgroundColors: [String: Color] = [
        "sky_blue": Color(hex: "B8D4E3"),
        "sunset_pink": Color(hex: "E8B4B8"),
        "mint_green": Color(hex: "B8E0D2"),
        "lavender": Color(hex: "C8B8E0"),
        "peach": Color(hex: "E8C8A8"),
        "cream": Color(hex: "F0E8D8"),
        "coral": Color(hex: "E8A898"),
        "sage": Color(hex: "B8C8A8"),
    ]

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Theme.bg3)
                        Rectangle()
                            .fill(Theme.lilac)
                            .frame(width: geo.size.width * (CGFloat(currentPage + 1) / CGFloat(totalPages)))
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .frame(height: 3)

                // Pages
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    namePage.tag(1)
                    countryPage.tag(2)
                    languagePage.tag(3)
                    interestPage.tag(4)
                    avatarPage.tag(5)
                    personalityPage.tag(6)
                    finishPage.tag(7)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }

    // MARK: - Page 1: Welcome

    private var welcomePage: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 12) {
                Text("daylight")
                    .font(Theme.typeFont(size: 36))
                    .foregroundStyle(Theme.txt)
                    .tracking(8)

                Text("letters that travel")
                    .font(Theme.typeFont(size: 12))
                    .foregroundStyle(Theme.tx3)
                    .tracking(4)

                Text("write real letters to pen pals\nacross the world. each letter travels\nbased on real distance.")
                    .font(Theme.typeFont(size: 11))
                    .foregroundStyle(Theme.tx3)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.top, 24)
            }

            Spacer()

            nextButton(label: "let's begin", enabled: true)
        }
        .padding(.horizontal, Theme.padding * 2)
        .padding(.bottom, 32)
    }

    // MARK: - Page 2: Name + Age

    private var namePage: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("who are you?")
                    .font(Theme.typeFont(size: 20))
                    .foregroundStyle(Theme.txt)
                    .tracking(3)

                VStack(spacing: 14) {
                    TextField("", text: $displayName, prompt: Text("display name").foregroundStyle(Theme.tx4))
                        .font(Theme.typeFont(size: 14))
                        .foregroundStyle(Theme.txt)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Theme.bg1)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Theme.brd, lineWidth: 0.5)
                        )

                    TextField("", text: $age, prompt: Text("age").foregroundStyle(Theme.tx4))
                        .font(Theme.typeFont(size: 14))
                        .foregroundStyle(Theme.txt)
                        .keyboardType(.numberPad)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Theme.bg1)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Theme.brd, lineWidth: 0.5)
                        )
                }
            }

            Spacer()

            nextButton(label: "next", enabled: !displayName.isEmpty)
        }
        .padding(.horizontal, Theme.padding * 2)
        .padding(.bottom, 32)
    }

    // MARK: - Page 3: Country

    private var countryPage: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("where are you?")
                    .font(Theme.typeFont(size: 20))
                    .foregroundStyle(Theme.txt)
                    .tracking(3)
                    .padding(.top, 32)

                Text("this determines letter travel time")
                    .font(Theme.typeFont(size: 10))
                    .foregroundStyle(Theme.tx4)
            }

            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(Countries.allNames, id: \.self) { country in
                        let isSelected = selectedCountry == country.lowercased()
                        Button {
                            selectedCountry = country.lowercased()
                        } label: {
                            HStack {
                                Text(country)
                                    .font(Theme.typeFont(size: 13))
                                    .foregroundStyle(isSelected ? Theme.txt : Theme.tx2)
                                Spacer()
                                if isSelected {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Theme.lilac)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(isSelected ? Theme.bg3 : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.top, 12)
            }

            nextButton(label: "next", enabled: !selectedCountry.isEmpty)
                .padding(.horizontal, Theme.padding * 2)
                .padding(.bottom, 32)
        }
    }

    // MARK: - Page 4: Languages

    private var languagePage: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("languages you speak")
                    .font(Theme.typeFont(size: 20))
                    .foregroundStyle(Theme.txt)
                    .tracking(3)
                    .padding(.top, 32)

                Text("select all that apply")
                    .font(Theme.typeFont(size: 10))
                    .foregroundStyle(Theme.tx4)
            }

            ScrollView {
                FlowLayout(spacing: 8) {
                    ForEach(allLanguages, id: \.self) { lang in
                        let isSelected = selectedLanguages.contains(lang)
                        Button {
                            if isSelected {
                                selectedLanguages.remove(lang)
                            } else {
                                selectedLanguages.insert(lang)
                            }
                        } label: {
                            Text(lang)
                                .font(Theme.typeFont(size: 11))
                                .foregroundStyle(isSelected ? Theme.bg : Theme.tx2)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(isSelected ? Theme.lilac : Theme.bg1)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(isSelected ? Theme.lilac : Theme.brd, lineWidth: 0.5)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.top, 20)
            }

            nextButton(label: "next", enabled: !selectedLanguages.isEmpty)
                .padding(.horizontal, Theme.padding * 2)
                .padding(.bottom, 32)
        }
    }

    // MARK: - Page 5: Interests

    private var interestPage: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("your interests")
                    .font(Theme.typeFont(size: 20))
                    .foregroundStyle(Theme.txt)
                    .tracking(3)
                    .padding(.top, 32)

                Text("pick at least 3")
                    .font(Theme.typeFont(size: 10))
                    .foregroundStyle(Theme.tx4)
            }

            ScrollView {
                FlowLayout(spacing: 8) {
                    ForEach(allInterests, id: \.self) { interest in
                        let isSelected = selectedInterests.contains(interest)
                        Button {
                            if isSelected {
                                selectedInterests.remove(interest)
                            } else {
                                selectedInterests.insert(interest)
                            }
                        } label: {
                            Text(interest)
                                .font(Theme.typeFont(size: 11))
                                .foregroundStyle(isSelected ? Theme.bg : Theme.tx2)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(isSelected ? Theme.lilac : Theme.bg1)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(isSelected ? Theme.lilac : Theme.brd, lineWidth: 0.5)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.top, 20)
            }

            nextButton(label: "next", enabled: selectedInterests.count >= 3)
                .padding(.horizontal, Theme.padding * 2)
                .padding(.bottom, 32)
        }
    }

    // MARK: - Page 6: Avatar Builder

    private var avatarPage: some View {
        VStack(spacing: 0) {
            Text("create your avatar")
                .font(Theme.typeFont(size: 20))
                .foregroundStyle(Theme.txt)
                .tracking(3)
                .padding(.top, 32)

            // Preview
            ZStack {
                Circle()
                    .fill(backgroundColors[avatarConfig.background ?? ""] ?? Theme.bg2)
                    .frame(width: 160, height: 160)
                Circle()
                    .strokeBorder(Theme.brd2, lineWidth: 1)
                    .frame(width: 160, height: 160)

                AvatarCircleView(config: avatarConfig, size: 140)
            }
            .padding(.top, 20)
            .padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 24) {
                    // Hair
                    VStack(alignment: .leading, spacing: 8) {
                        Text("HAIR")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .tracking(2)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(AvatarCatalog.hairStyles) { style in
                                    let isSelected = style.id == avatarConfig.hairStyle
                                    Button {
                                        avatarConfig.hairStyle = style.id
                                    } label: {
                                        VStack(spacing: 4) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(isSelected ? Theme.bg3 : Theme.bg1)
                                                    .frame(width: 60, height: 60)
                                                RoundedRectangle(cornerRadius: 10)
                                                    .strokeBorder(isSelected ? Theme.lilac : Theme.brd, lineWidth: isSelected ? 1.5 : 0.5)
                                                    .frame(width: 60, height: 60)
                                                Image("avatar_\(style.id)_\(avatarConfig.skinTone)")
                                                    .interpolation(.none)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 44, height: 44)
                                            }
                                            Text(style.label)
                                                .font(Theme.typeFont(size: 8))
                                                .foregroundStyle(isSelected ? Theme.txt : Theme.tx4)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // Skin
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SKIN")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .tracking(2)

                        HStack(spacing: 8) {
                            ForEach(AvatarCatalog.skinTones) { tone in
                                let isSelected = tone.id == avatarConfig.skinTone
                                Button {
                                    avatarConfig.skinTone = tone.id
                                } label: {
                                    VStack(spacing: 4) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(isSelected ? Theme.bg3 : Theme.bg1)
                                                .frame(width: 60, height: 60)
                                            RoundedRectangle(cornerRadius: 10)
                                                .strokeBorder(isSelected ? Theme.lilac : Theme.brd, lineWidth: isSelected ? 1.5 : 0.5)
                                                .frame(width: 60, height: 60)
                                            Image("avatar_\(avatarConfig.hairStyle)_\(tone.id)")
                                                .interpolation(.none)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 44, height: 44)
                                        }
                                        Text(tone.label)
                                            .font(Theme.typeFont(size: 8))
                                            .foregroundStyle(isSelected ? Theme.txt : Theme.tx4)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            Spacer()
                        }
                    }

                    // Background
                    VStack(alignment: .leading, spacing: 8) {
                        Text("BACKGROUND")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .tracking(2)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(AvatarConfig.backgrounds, id: \.self) { bg in
                                    let isSelected = avatarConfig.background == bg
                                    Button {
                                        avatarConfig.background = bg
                                    } label: {
                                        Circle()
                                            .fill(backgroundColors[bg] ?? Theme.bg2)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Circle()
                                                    .strokeBorder(isSelected ? Theme.lilac : Theme.brd, lineWidth: isSelected ? 2 : 0.5)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.bottom, 20)
            }

            nextButton(label: "next", enabled: true)
                .padding(.horizontal, Theme.padding * 2)
                .padding(.bottom, 32)
        }
    }

    // MARK: - Page 7: MBTI + Zodiac (optional)

    private var personalityPage: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("personality")
                    .font(Theme.typeFont(size: 20))
                    .foregroundStyle(Theme.txt)
                    .tracking(3)
                    .padding(.top, 32)

                Text("optional - helps find pen pals")
                    .font(Theme.typeFont(size: 10))
                    .foregroundStyle(Theme.tx4)
            }

            ScrollView {
                VStack(spacing: 28) {
                    // MBTI
                    VStack(alignment: .leading, spacing: 10) {
                        Text("MBTI")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .tracking(2)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 4), spacing: 6) {
                            ForEach(mbtiTypes, id: \.self) { type in
                                let isSelected = mbti == type
                                Button {
                                    mbti = mbti == type ? "" : type
                                } label: {
                                    Text(type.lowercased())
                                        .font(Theme.typeFont(size: 10))
                                        .foregroundStyle(isSelected ? Theme.bg : Theme.tx2)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(isSelected ? Theme.lilac : Theme.bg1)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .strokeBorder(isSelected ? Theme.lilac : Theme.brd, lineWidth: 0.5)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // Zodiac
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ZODIAC")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .tracking(2)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                            ForEach(zodiacSigns, id: \.self) { sign in
                                let isSelected = zodiac == sign
                                Button {
                                    zodiac = zodiac == sign ? "" : sign
                                } label: {
                                    Text(sign)
                                        .font(Theme.typeFont(size: 10))
                                        .foregroundStyle(isSelected ? Theme.bg : Theme.tx2)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(isSelected ? Theme.lilac : Theme.bg1)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .strokeBorder(isSelected ? Theme.lilac : Theme.brd, lineWidth: 0.5)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.top, 20)
            }

            nextButton(label: "next", enabled: true)
                .padding(.horizontal, Theme.padding * 2)
                .padding(.bottom, 32)
        }
    }

    // MARK: - Page 8: Finish

    private var finishPage: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                AvatarCircleView(config: avatarConfig, size: 100)

                Text(displayName.isEmpty ? "friend" : displayName)
                    .font(Theme.typeFont(size: 22))
                    .foregroundStyle(Theme.txt)
                    .tracking(3)

                Text("your letters are waiting")
                    .font(Theme.typeFont(size: 11))
                    .foregroundStyle(Theme.tx3)
                    .tracking(2)
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(Theme.typeFont(size: 10))
                    .foregroundStyle(Theme.pink)
                    .padding(.top, 12)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            Button {
                completeOnboarding()
            } label: {
                Group {
                    if isSaving {
                        ProgressView()
                            .tint(Theme.bg)
                    } else {
                        Text("start writing")
                            .font(Theme.typeFont(size: 14))
                    }
                }
                .foregroundStyle(Theme.bg)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.lilac)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(isSaving)
            .padding(.horizontal, Theme.padding * 2)
            .padding(.bottom, 32)
        }
    }

    // MARK: - Helpers

    private func nextButton(label: String, enabled: Bool) -> some View {
        Button {
            withAnimation {
                currentPage = min(currentPage + 1, totalPages - 1)
            }
        } label: {
            Text(label)
                .font(Theme.typeFont(size: 14))
                .foregroundStyle(enabled ? Theme.bg : Theme.tx4)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(enabled ? Theme.lilac : Theme.bg2)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(!enabled)
    }

    private func completeOnboarding() {
        guard let userId = auth.currentUser?.id else { return }
        isSaving = true
        errorMessage = nil

        Task {
            do {
                let userService = UserService()
                let coords = Countries.coords[selectedCountry]

                var updatedUser = auth.currentUser ?? AppUser.empty
                updatedUser.displayName = displayName
                updatedUser.age = Int(age)
                updatedUser.country = selectedCountry
                updatedUser.latitude = coords?.lat
                updatedUser.longitude = coords?.lng
                updatedUser.languages = Array(selectedLanguages)
                updatedUser.interests = Array(selectedInterests)
                updatedUser.avatarConfig = avatarConfig
                updatedUser.mbti = mbti.isEmpty ? nil : mbti
                updatedUser.zodiac = zodiac.isEmpty ? nil : zodiac
                updatedUser.onboardingComplete = true
                updatedUser.lastActiveAt = Date()

                try await userService.updateProfile(updatedUser)
                auth.currentUser = updatedUser

                isSaving = false
            } catch {
                errorMessage = error.localizedDescription
                isSaving = false
            }
        }
    }
}
