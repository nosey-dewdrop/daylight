import SwiftUI

struct SettingsView: View {
    @Environment(AuthService.self) private var auth
    @Environment(\.dismiss) private var dismiss

    @State private var displayName = ""
    @State private var selectedLanguages: Set<String> = []
    @State private var selectedInterests: Set<String> = []
    @State private var locationVisible = true
    @State private var isSaving = false
    @State private var showSignOutConfirm = false
    @State private var errorMessage: String?
    @State private var successMessage: String?

    private let userService = UserService()

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

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Text("cancel")
                                    .font(Theme.typeFont(size: 13))
                                    .foregroundStyle(Theme.tx3)
                            }
                            Spacer()
                            Text("settings")
                                .font(Theme.typeFont(size: 16))
                                .foregroundStyle(Theme.txt)
                                .tracking(2)
                            Spacer()
                            Button {
                                saveProfile()
                            } label: {
                                if isSaving {
                                    ProgressView()
                                        .tint(Theme.lilac)
                                } else {
                                    Text("save")
                                        .font(Theme.typeFont(size: 13))
                                        .foregroundStyle(Theme.lilac)
                                }
                            }
                            .disabled(isSaving)
                        }
                        .padding(.horizontal, Theme.padding)
                        .padding(.top, 16)

                        // Feedback
                        if let errorMessage {
                            Text(errorMessage)
                                .font(Theme.typeFont(size: 10))
                                .foregroundStyle(Theme.pink)
                        }
                        if let successMessage {
                            Text(successMessage)
                                .font(Theme.typeFont(size: 10))
                                .foregroundStyle(Theme.deliveredColor)
                        }

                        // Display name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DISPLAY NAME")
                                .font(Theme.typeFont(size: 9))
                                .foregroundStyle(Theme.tx4)
                                .tracking(2)

                            TextField("", text: $displayName, prompt: Text("your name").foregroundStyle(Theme.tx4))
                                .font(Theme.typeFont(size: 14))
                                .foregroundStyle(Theme.txt)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Theme.bg1)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(Theme.brd, lineWidth: 0.5)
                                )
                        }
                        .padding(.horizontal, Theme.padding)

                        // Location visibility
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PRIVACY")
                                .font(Theme.typeFont(size: 9))
                                .foregroundStyle(Theme.tx4)
                                .tracking(2)

                            HStack {
                                Text("show location to pen pals")
                                    .font(Theme.typeFont(size: 12))
                                    .foregroundStyle(Theme.txt)
                                Spacer()
                                Toggle("", isOn: $locationVisible)
                                    .tint(Theme.lilac)
                                    .labelsHidden()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Theme.bg1)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(Theme.brd, lineWidth: 0.5)
                            )
                        }
                        .padding(.horizontal, Theme.padding)

                        // Languages
                        VStack(alignment: .leading, spacing: 8) {
                            Text("LANGUAGES")
                                .font(Theme.typeFont(size: 9))
                                .foregroundStyle(Theme.tx4)
                                .tracking(2)

                            FlowLayout(spacing: 6) {
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
                                            .font(Theme.typeFont(size: 10))
                                            .foregroundStyle(isSelected ? Theme.bg : Theme.tx2)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
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
                        }
                        .padding(.horizontal, Theme.padding)

                        // Interests
                        VStack(alignment: .leading, spacing: 8) {
                            Text("INTERESTS")
                                .font(Theme.typeFont(size: 9))
                                .foregroundStyle(Theme.tx4)
                                .tracking(2)

                            FlowLayout(spacing: 6) {
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
                                            .font(Theme.typeFont(size: 10))
                                            .foregroundStyle(isSelected ? Theme.bg : Theme.tx2)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
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
                        }
                        .padding(.horizontal, Theme.padding)

                        // Sign out
                        Button {
                            showSignOutConfirm = true
                        } label: {
                            Text("sign out")
                                .font(Theme.typeFont(size: 13))
                                .foregroundStyle(Theme.pink)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Theme.bg1)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(Theme.pink.opacity(0.3), lineWidth: 0.5)
                                )
                        }
                        .padding(.horizontal, Theme.padding)

                        // App version
                        Text("daylight v1.0")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .padding(.top, 8)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            loadCurrentValues()
        }
        .alert("sign out?", isPresented: $showSignOutConfirm) {
            Button("cancel", role: .cancel) { }
            Button("sign out", role: .destructive) {
                signOut()
            }
        } message: {
            Text("you'll need to sign in again")
        }
    }

    private func loadCurrentValues() {
        guard let user = auth.currentUser else { return }
        displayName = user.displayName ?? ""
        selectedLanguages = Set(user.languages)
        selectedInterests = Set(user.interests)
        locationVisible = user.locationVisible
    }

    private func saveProfile() {
        guard var user = auth.currentUser else { return }
        isSaving = true
        errorMessage = nil
        successMessage = nil

        user.displayName = displayName.isEmpty ? nil : displayName
        user.languages = Array(selectedLanguages)
        user.interests = Array(selectedInterests)
        user.locationVisible = locationVisible
        user.lastActiveAt = Date()

        Task {
            do {
                try await userService.updateProfile(user)
                auth.currentUser = user
                await MainActor.run {
                    isSaving = false
                    successMessage = "saved"
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isSaving = false
                }
            }
        }
    }

    private func signOut() {
        Task {
            try? await auth.signOut()
            await MainActor.run {
                dismiss()
            }
        }
    }
}
