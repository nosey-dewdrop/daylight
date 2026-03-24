import SwiftUI

struct AvatarBuilderView: View {
    @Environment(AuthService.self) private var authService
    @Environment(UserService.self) private var userService
    @Environment(\.dismiss) private var dismiss

    @State private var config: AvatarConfig = .default
    @State private var isSaving = false
    @State private var selectedCategory = "Face"

    private let categories = ["Face", "Hair", "Eyes", "Mouth", "Clothing", "Accessory", "Colors"]

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    // Large avatar preview
                    AvatarView(config: config, size: 150)
                        .padding(.top, 16)

                    // Category tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: { selectedCategory = category }) {
                                    Text(category)
                                        .font(DaylightTheme.captionFont)
                                        .foregroundColor(selectedCategory == category ? .white : DaylightTheme.rose)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(selectedCategory == category ? DaylightTheme.rose : DaylightTheme.blue.opacity(0.3))
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, DaylightTheme.padding)
                    }

                    // Options for selected category
                    ScrollView {
                        VStack(spacing: 16) {
                            switch selectedCategory {
                            case "Face":
                                optionGrid(title: "Face Shape", options: AvatarConfig.FaceShape.allCases, current: config.faceShape) { config.faceShape = $0 }
                                skinColorPicker
                            case "Hair":
                                optionGrid(title: "Hair Style", options: AvatarConfig.HairStyle.allCases, current: config.hairStyle) { config.hairStyle = $0 }
                                colorPicker(title: "Hair Color", colors: hairColors, current: config.hairColor) { config.hairColor = $0 }
                            case "Eyes":
                                optionGrid(title: "Eye Shape", options: AvatarConfig.EyeStyle.allCases, current: config.eyeStyle) { config.eyeStyle = $0 }
                                optionGrid(title: "Eyebrows", options: AvatarConfig.EyebrowStyle.allCases, current: config.eyebrowStyle) { config.eyebrowStyle = $0 }
                                colorPicker(title: "Eye Color", colors: eyeColors, current: config.eyeColor) { config.eyeColor = $0 }
                            case "Mouth":
                                optionGrid(title: "Mouth Style", options: AvatarConfig.MouthStyle.allCases, current: config.mouthStyle) { config.mouthStyle = $0 }
                            case "Clothing":
                                optionGrid(title: "Clothing Style", options: AvatarConfig.ClothingStyle.allCases, current: config.clothingStyle) { config.clothingStyle = $0 }
                                colorPicker(title: "Clothing Color", colors: clothingColors, current: config.clothingColor) { config.clothingColor = $0 }
                            case "Accessory":
                                optionGrid(title: "Accessory", options: AvatarConfig.Accessory.allCases, current: config.accessory) { config.accessory = $0 }
                            case "Colors":
                                colorPicker(title: "Background", colors: backgroundColors, current: config.backgroundColor) { config.backgroundColor = $0 }
                            default:
                                EmptyView()
                            }
                        }
                        .padding(DaylightTheme.padding)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(DaylightTheme.rose)
                }

                ToolbarItem(placement: .principal) {
                    Text("Avatar Builder")
                        .font(DaylightTheme.headlineFont)
                        .foregroundColor(DaylightTheme.text)
                }

                ToolbarItem(placement: .primaryAction) {
                    Button(action: save) {
                        if isSaving {
                            ProgressView().tint(DaylightTheme.rose)
                        } else {
                            Text("Save")
                                .font(DaylightTheme.bodyFont)
                                .foregroundColor(DaylightTheme.rose)
                        }
                    }
                    .disabled(isSaving)
                }
            }
            .onAppear {
                if let existing = authService.currentProfile?.avatarConfig {
                    config = existing
                }
            }
        }
    }

    private func optionGrid<T: RawRepresentable & CaseIterable & Hashable>(
        title: String,
        options: [T],
        current: T,
        onSelect: @escaping (T) -> Void
    ) -> some View where T.RawValue == String {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(DaylightTheme.captionFont)
                .foregroundColor(DaylightTheme.textSub)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                ForEach(Array(options), id: \.self) { option in
                    Button(action: { onSelect(option) }) {
                        Text(option.rawValue.capitalized)
                            .font(DaylightTheme.captionFont)
                            .foregroundColor(current == option ? .white : DaylightTheme.rose)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: DaylightTheme.smallCornerRadius)
                                    .fill(current == option ? DaylightTheme.rose : DaylightTheme.blue.opacity(0.2))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var skinColorPicker: some View {
        colorPicker(title: "Skin Tone", colors: skinColors, current: config.skinTone) { config.skinTone = $0 }
    }

    private func colorPicker(title: String, colors: [String], current: String, onSelect: @escaping (String) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(DaylightTheme.captionFont)
                .foregroundColor(DaylightTheme.textSub)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 8) {
                ForEach(colors, id: \.self) { hex in
                    Button(action: { onSelect(hex) }) {
                        Circle()
                            .fill(Color(hex: hex))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .stroke(current == hex ? DaylightTheme.rose : Color.clear, lineWidth: 3)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .padding(1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private let skinColors = ["#FDEBD0", "#F5D0A9", "#E8B88A", "#D4956B", "#C07850", "#A66238", "#8D5524", "#6B4423", "#4A2C0F"]
    private let hairColors = ["#2C2C2C", "#4A3728", "#6B4423", "#8B6F47", "#D4A574", "#E8C07A", "#F5E6D3", "#C0392B", "#922B21", "#8E44AD", "#2980B9"]
    private let eyeColors = ["#5B4A3F", "#2C2C2C", "#6B8E23", "#2980B9", "#7D6608", "#1ABC9C", "#8E44AD"]
    private let clothingColors = ["#7EB5D6", "#E74C3C", "#2ECC71", "#F39C12", "#9B59B6", "#2C2C2C", "#F5E6D3", "#E8B4B8", "#1ABC9C", "#D35400"]
    private let backgroundColors = ["#B8D4E3", "#A8D8EA", "#D4F1F9", "#F5E6D3", "#E8D5BC", "#FADBD8", "#D5F5E3", "#FCF3CF", "#E8DAEF", "#D6EAF8"]

    private func save() {
        guard let userId = authService.currentUser?.id else { return }
        isSaving = true
        let update = ProfileUpdate(avatarConfig: config)
        Task {
            do {
                try await userService.updateProfile(update, userId: userId)
                await authService.refreshProfile()
                dismiss()
            } catch {
                print("Save avatar error: \(error)")
            }
            isSaving = false
        }
    }
}
