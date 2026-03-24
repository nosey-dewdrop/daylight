import SwiftUI

struct OnboardingView: View {
    @Environment(AuthService.self) private var authService
    @Environment(UserService.self) private var userService
    @State private var currentStep = 0
    @State private var displayName = ""
    @State private var age = 18
    @State private var selectedCountry: CountryInfo?
    @State private var selectedLanguages: Set<String> = []
    @State private var selectedInterests: Set<String> = []
    @State private var mbti: String?
    @State private var zodiac: String?
    @State private var avatarConfig = AvatarConfig.default
    @State private var isLoading = false

    private let totalSteps = 6

    var body: some View {
        ZStack {
            DaylightTheme.skyGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                progressBar

                ScrollView {
                    VStack(spacing: 24) {
                        switch currentStep {
                        case 0: nameStep
                        case 1: ageCountryStep
                        case 2: languagesStep
                        case 3: interestsStep
                        case 4: personalityStep
                        case 5: avatarStep
                        default: EmptyView()
                        }
                    }
                    .padding(24)
                }

                // Navigation buttons
                navigationButtons
            }
        }
        .task {
            await userService.fetchInterests()
        }
    }

    private var progressBar: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? DaylightTheme.rose : DaylightTheme.blue.opacity(0.3))
                    .frame(height: 4)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }

    private var nameStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "hand.wave.fill")
                .font(.system(size: 50))
                .foregroundColor(DaylightTheme.softGold)

            Text("What should we call you?")
                .font(DaylightTheme.titleFont)
                .foregroundColor(DaylightTheme.text)

            Text("This is how your pen pals will know you")
                .font(DaylightTheme.letterFont)
                .foregroundColor(DaylightTheme.textSub)

            TextField("Your name", text: $displayName)
                .font(DaylightTheme.headlineFont)
                .multilineTextAlignment(.center)
                .padding(16)
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius))
        }
        .padding(.top, 40)
    }

    private var ageCountryStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe.americas")
                .font(.system(size: 50))
                .foregroundColor(DaylightTheme.rose)

            Text("Where are you from?")
                .font(DaylightTheme.titleFont)
                .foregroundColor(DaylightTheme.text)

            VStack(alignment: .leading, spacing: 8) {
                Text("Age")
                    .font(DaylightTheme.captionFont)
                    .foregroundColor(DaylightTheme.textSub)

                Stepper(value: $age, in: 13...99) {
                    Text("\(age) years old")
                        .font(DaylightTheme.headlineFont)
                        .foregroundColor(DaylightTheme.text)
                }
                .padding(12)
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.smallCornerRadius))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Country")
                    .font(DaylightTheme.captionFont)
                    .foregroundColor(DaylightTheme.textSub)

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 4) {
                        ForEach(Countries.all) { country in
                            Button(action: { selectedCountry = country }) {
                                HStack {
                                    Text(country.flag)
                                    Text(country.name)
                                        .font(DaylightTheme.bodyFont)
                                        .foregroundColor(DaylightTheme.text)
                                    Spacer()
                                    if selectedCountry?.id == country.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(DaylightTheme.rose)
                                    }
                                }
                                .padding(10)
                                .background(
                                    selectedCountry?.id == country.id ?
                                        DaylightTheme.blue.opacity(0.2) : Color.white.opacity(0.5)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.smallCornerRadius))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(maxHeight: 250)
            }
        }
    }

    private var languagesStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "text.bubble.fill")
                .font(.system(size: 50))
                .foregroundColor(DaylightTheme.green)

            Text("Which languages do you speak?")
                .font(DaylightTheme.titleFont)
                .foregroundColor(DaylightTheme.text)
                .multilineTextAlignment(.center)

            Text("Select all that apply")
                .font(DaylightTheme.letterFont)
                .foregroundColor(DaylightTheme.textSub)

            FlowLayout(spacing: 8) {
                ForEach(Countries.languages, id: \.self) { language in
                    InterestChip(
                        text: language,
                        isSelected: selectedLanguages.contains(language)
                    ) {
                        if selectedLanguages.contains(language) {
                            selectedLanguages.remove(language)
                        } else {
                            selectedLanguages.insert(language)
                        }
                    }
                }
            }
        }
    }

    private var interestsStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(DaylightTheme.pink)

            Text("What are you into?")
                .font(DaylightTheme.titleFont)
                .foregroundColor(DaylightTheme.text)

            Text("Pick at least 3 interests")
                .font(DaylightTheme.letterFont)
                .foregroundColor(DaylightTheme.textSub)

            let grouped = Dictionary(grouping: userService.allInterests, by: { $0.category })
            ForEach(Array(grouped.keys.sorted()), id: \.self) { category in
                VStack(alignment: .leading, spacing: 8) {
                    Text(category)
                        .font(DaylightTheme.captionFont)
                        .foregroundColor(DaylightTheme.textSub)

                    FlowLayout(spacing: 8) {
                        ForEach(grouped[category] ?? [], id: \.id) { interest in
                            InterestChip(
                                text: interest.name,
                                isSelected: selectedInterests.contains(interest.name)
                            ) {
                                if selectedInterests.contains(interest.name) {
                                    selectedInterests.remove(interest.name)
                                } else {
                                    selectedInterests.insert(interest.name)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private var personalityStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundColor(DaylightTheme.softGold)

            Text("Optional: Personality")
                .font(DaylightTheme.titleFont)
                .foregroundColor(DaylightTheme.text)

            Text("These help find compatible pen pals")
                .font(DaylightTheme.letterFont)
                .foregroundColor(DaylightTheme.textSub)

            VStack(alignment: .leading, spacing: 8) {
                Text("MBTI Type")
                    .font(DaylightTheme.captionFont)
                    .foregroundColor(DaylightTheme.textSub)

                FlowLayout(spacing: 8) {
                    ForEach(Countries.mbtiTypes, id: \.self) { type in
                        InterestChip(text: type, isSelected: mbti == type) {
                            mbti = mbti == type ? nil : type
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Zodiac Sign")
                    .font(DaylightTheme.captionFont)
                    .foregroundColor(DaylightTheme.textSub)

                FlowLayout(spacing: 8) {
                    ForEach(Countries.zodiacSigns, id: \.self) { sign in
                        InterestChip(text: sign, isSelected: zodiac == sign) {
                            zodiac = zodiac == sign ? nil : sign
                        }
                    }
                }
            }
        }
    }

    private var avatarStep: some View {
        VStack(spacing: 20) {
            Text("Create Your Avatar")
                .font(DaylightTheme.titleFont)
                .foregroundColor(DaylightTheme.text)

            AvatarView(config: avatarConfig, size: 120)
                .padding()

            // Quick avatar customization
            VStack(spacing: 12) {
                avatarPicker(title: "Face Shape", options: AvatarConfig.FaceShape.allCases) { avatarConfig.faceShape = $0 } current: { avatarConfig.faceShape.rawValue }
                avatarPicker(title: "Hair Style", options: AvatarConfig.HairStyle.allCases) { avatarConfig.hairStyle = $0 } current: { avatarConfig.hairStyle.rawValue }
                avatarPicker(title: "Eyes", options: AvatarConfig.EyeStyle.allCases) { avatarConfig.eyeStyle = $0 } current: { avatarConfig.eyeStyle.rawValue }
                avatarPicker(title: "Mouth", options: AvatarConfig.MouthStyle.allCases) { avatarConfig.mouthStyle = $0 } current: { avatarConfig.mouthStyle.rawValue }
                avatarPicker(title: "Clothing", options: AvatarConfig.ClothingStyle.allCases) { avatarConfig.clothingStyle = $0 } current: { avatarConfig.clothingStyle.rawValue }
                avatarPicker(title: "Accessory", options: AvatarConfig.Accessory.allCases) { avatarConfig.accessory = $0 } current: { avatarConfig.accessory.rawValue }

                // Color pickers
                colorRow(title: "Skin Tone", colors: ["#F5D0A9", "#E8B88A", "#D4956B", "#C07850", "#8D5524", "#4A2C0F"]) {
                    avatarConfig.skinTone = $0
                }
                colorRow(title: "Hair Color", colors: ["#4A3728", "#8B6F47", "#D4A574", "#E8C07A", "#C0392B", "#2C2C2C", "#F5E6D3"]) {
                    avatarConfig.hairColor = $0
                }
                colorRow(title: "Clothing Color", colors: ["#7EB5D6", "#E74C3C", "#2ECC71", "#F39C12", "#9B59B6", "#2C2C2C", "#F5E6D3"]) {
                    avatarConfig.clothingColor = $0
                }
            }
        }
    }

    private func avatarPicker<T: RawRepresentable & CaseIterable & Hashable>(
        title: String,
        options: [T],
        set: @escaping (T) -> Void,
        current: @escaping () -> String
    ) -> some View where T.RawValue == String {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(DaylightTheme.captionFont)
                .foregroundColor(DaylightTheme.textSub)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(Array(options), id: \.self) { option in
                        Button(action: { set(option) }) {
                            Text(option.rawValue.capitalized)
                                .font(.system(size: 11, design: .serif))
                                .foregroundColor(current() == option.rawValue ? .white : DaylightTheme.rose)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(current() == option.rawValue ? DaylightTheme.rose : DaylightTheme.blue.opacity(0.3))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func colorRow(title: String, colors: [String], onSelect: @escaping (String) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(DaylightTheme.captionFont)
                .foregroundColor(DaylightTheme.textSub)

            HStack(spacing: 8) {
                ForEach(colors, id: \.self) { hex in
                    Circle()
                        .fill(Color(hex: hex))
                        .frame(width: 28, height: 28)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 1)
                        .onTapGesture { onSelect(hex) }
                }
            }
        }
    }

    private var navigationButtons: some View {
        HStack {
            if currentStep > 0 {
                Button(action: { withAnimation { currentStep -= 1 } }) {
                    Text("Back")
                        .daylightButton(isPrimary: false)
                }
            }

            Spacer()

            if currentStep < totalSteps - 1 {
                Button(action: { withAnimation { currentStep += 1 } }) {
                    Text("Next")
                        .daylightButton()
                }
                .disabled(!canProceed)
            } else {
                Button(action: completeOnboarding) {
                    Group {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Start Writing")
                        }
                    }
                    .daylightButton()
                }
                .disabled(isLoading)
            }
        }
        .padding(24)
    }

    private var canProceed: Bool {
        switch currentStep {
        case 0: return !displayName.isEmpty
        case 1: return selectedCountry != nil
        case 2: return !selectedLanguages.isEmpty
        case 3: return selectedInterests.count >= 3
        default: return true
        }
    }

    private func completeOnboarding() {
        guard let userId = authService.currentUser?.id else { return }
        isLoading = true

        let update = ProfileUpdate(
            displayName: displayName,
            avatarConfig: avatarConfig,
            age: age,
            country: selectedCountry?.name,
            city: nil,
            latitude: selectedCountry?.latitude,
            longitude: selectedCountry?.longitude,
            languages: Array(selectedLanguages),
            interests: Array(selectedInterests),
            mbti: mbti,
            zodiac: zodiac,
            bio: nil,
            xp: 0,
            level: 1,
            onboardingComplete: true
        )

        Task {
            do {
                try await userService.updateProfile(update, userId: userId)
                await authService.refreshProfile()
            } catch {
                print("Onboarding error: \(error)")
            }
            isLoading = false
        }
    }
}
