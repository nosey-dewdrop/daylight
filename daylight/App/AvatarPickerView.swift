import SwiftUI

struct AvatarPickerView: View {
    @Environment(AuthService.self) private var auth
    @Environment(\.dismiss) private var dismiss
    @State private var config = AvatarConfig.default
    @State private var isSaving = false

    private let userService = UserService()

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
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("cancel")
                            .font(Theme.typeFont(size: 14))
                            .foregroundStyle(Theme.tx3)
                    }
                    Spacer()
                    Text("avatar")
                        .font(Theme.typeFont(size: 18))
                        .foregroundStyle(Theme.txt)
                        .tracking(3)
                    Spacer()
                    Button {
                        saveAvatar()
                    } label: {
                        if isSaving {
                            ProgressView()
                                .tint(Theme.lilac)
                        } else {
                            Text("save")
                                .font(Theme.typeFont(size: 14))
                                .foregroundStyle(Theme.lilac)
                        }
                    }
                    .disabled(isSaving)
                }
                .padding(.horizontal, Theme.padding)
                .padding(.vertical, 14)

                // Big avatar preview
                ZStack {
                    Circle()
                        .fill(backgroundColors[config.background ?? ""] ?? Theme.bg2)
                        .frame(width: 180, height: 180)
                    Circle()
                        .strokeBorder(Theme.brd2, lineWidth: 1)
                        .frame(width: 180, height: 180)

                    AvatarCircleView(config: config, size: 150)
                }
                .padding(.top, 8)
                .padding(.bottom, 24)

                // Part selectors
                ScrollView {
                    VStack(spacing: 28) {
                        // Hair style picker
                        VStack(alignment: .leading, spacing: 10) {
                            Text("HAIR")
                                .font(Theme.typeFont(size: 10))
                                .foregroundStyle(Theme.tx4)
                                .tracking(2)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(AvatarCatalog.hairStyles) { style in
                                        let isSelected = style.id == config.hairStyle
                                        Button {
                                            withAnimation(.easeInOut(duration: 0.15)) {
                                                config.hairStyle = style.id
                                            }
                                        } label: {
                                            VStack(spacing: 6) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(isSelected ? Theme.bg3 : Theme.bg1)
                                                        .frame(width: 72, height: 72)
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .strokeBorder(
                                                            isSelected ? Theme.lilac : Theme.brd,
                                                            lineWidth: isSelected ? 1.5 : 0.5
                                                        )
                                                        .frame(width: 72, height: 72)
                                                    Image("avatar_\(style.id)_\(config.skinTone)")
                                                        .interpolation(.none)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 52, height: 52)
                                                }
                                                Text(style.label)
                                                    .font(Theme.typeFont(size: 9))
                                                    .foregroundStyle(isSelected ? Theme.txt : Theme.tx4)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        // Skin tone picker
                        VStack(alignment: .leading, spacing: 10) {
                            Text("SKIN")
                                .font(Theme.typeFont(size: 10))
                                .foregroundStyle(Theme.tx4)
                                .tracking(2)

                            HStack(spacing: 10) {
                                ForEach(AvatarCatalog.skinTones) { tone in
                                    let isSelected = tone.id == config.skinTone
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.15)) {
                                            config.skinTone = tone.id
                                        }
                                    } label: {
                                        VStack(spacing: 6) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(isSelected ? Theme.bg3 : Theme.bg1)
                                                    .frame(width: 72, height: 72)
                                                RoundedRectangle(cornerRadius: 12)
                                                    .strokeBorder(
                                                        isSelected ? Theme.lilac : Theme.brd,
                                                        lineWidth: isSelected ? 1.5 : 0.5
                                                    )
                                                    .frame(width: 72, height: 72)
                                                Image("avatar_\(config.hairStyle)_\(tone.id)")
                                                    .interpolation(.none)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 52, height: 52)
                                            }
                                            Text(tone.label)
                                                .font(Theme.typeFont(size: 9))
                                                .foregroundStyle(isSelected ? Theme.txt : Theme.tx4)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                                Spacer()
                            }
                        }

                        // Background picker
                        VStack(alignment: .leading, spacing: 10) {
                            Text("BACKGROUND")
                                .font(Theme.typeFont(size: 10))
                                .foregroundStyle(Theme.tx4)
                                .tracking(2)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(AvatarConfig.backgrounds, id: \.self) { bg in
                                        let isSelected = config.background == bg
                                        Button {
                                            config.background = bg
                                        } label: {
                                            Circle()
                                                .fill(backgroundColors[bg] ?? Theme.bg2)
                                                .frame(width: 44, height: 44)
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
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            if let existing = auth.currentUser?.avatarConfig {
                config = existing
            }
        }
    }

    private func saveAvatar() {
        guard var user = auth.currentUser else { return }
        isSaving = true
        user.avatarConfig = config

        Task {
            do {
                try await userService.updateProfile(user)
                auth.currentUser = user
                await MainActor.run {
                    isSaving = false
                    dismiss()
                }
            } catch {
                isSaving = false
            }
        }
    }
}

#Preview {
    AvatarPickerView()
        .preferredColorScheme(.light)
}
