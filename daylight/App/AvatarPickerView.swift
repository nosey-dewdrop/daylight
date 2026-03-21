import SwiftUI

struct AvatarPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSkin = 0
    @State private var selectedEyes = 0
    @State private var selectedMouth = 0
    @State private var selectedHair = 0

    // Placeholder parts — will be replaced with drawn PNG assets
    private let skins = ["🟫", "🟧", "🟨"]
    private let skinLabels = ["dark", "medium", "light"]
    private let eyes = ["◉", "◡", "▸◂", "◎"]
    private let eyeLabels = ["round", "sleepy", "cat", "wide"]
    private let mouths = ["‿", "—", "ω", "◡"]
    private let mouthLabels = ["smile", "neutral", "cat", "soft"]
    private let hairs = ["✂", "〰", "❀", "◎"]
    private let hairLabels = ["short", "long", "curly", "bun"]

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
                            .font(Theme.typeFont(size: 12))
                            .foregroundStyle(Theme.tx3)
                    }
                    Spacer()
                    Text("avatar")
                        .font(Theme.typeFont(size: 16))
                        .foregroundStyle(Theme.txt)
                        .tracking(3)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("save")
                            .font(Theme.typeFont(size: 12))
                            .foregroundStyle(Theme.lilac)
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.vertical, 12)

                // Avatar preview
                ZStack {
                    Circle()
                        .fill(Theme.bg2)
                        .frame(width: 120, height: 120)
                    Circle()
                        .strokeBorder(Theme.brd2, lineWidth: 1)
                        .frame(width: 120, height: 120)

                    // Layered preview — placeholder until PNGs arrive
                    VStack(spacing: 2) {
                        Text(hairs[selectedHair])
                            .font(.system(size: 20))
                        HStack(spacing: 8) {
                            Text(eyes[selectedEyes])
                                .font(.system(size: 16))
                            Text(eyes[selectedEyes])
                                .font(.system(size: 16))
                        }
                        Text(mouths[selectedMouth])
                            .font(.system(size: 14))
                    }
                    .foregroundStyle(Theme.txt)
                }
                .padding(.vertical, 20)

                // Part selectors
                ScrollView {
                    VStack(spacing: 20) {
                        PartSelector(
                            title: "SKIN",
                            items: skinLabels,
                            icons: skins,
                            selected: $selectedSkin
                        )

                        PartSelector(
                            title: "EYES",
                            items: eyeLabels,
                            icons: eyes,
                            selected: $selectedEyes
                        )

                        PartSelector(
                            title: "MOUTH",
                            items: mouthLabels,
                            icons: mouths,
                            selected: $selectedMouth
                        )

                        PartSelector(
                            title: "HAIR",
                            items: hairLabels,
                            icons: hairs,
                            selected: $selectedHair
                        )
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

// MARK: - Part Selector Row

struct PartSelector: View {
    let title: String
    let items: [String]
    let icons: [String]
    @Binding var selected: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Theme.typeFont(size: 9))
                .foregroundStyle(Theme.tx4)
                .tracking(2)

            HStack(spacing: 8) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, label in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selected = index
                        }
                    } label: {
                        VStack(spacing: 4) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selected == index ? Theme.bg3 : Theme.bg1)
                                    .frame(width: 56, height: 56)
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(
                                        selected == index ? Theme.lilac.opacity(0.5) : Theme.brd,
                                        lineWidth: selected == index ? 1 : 0.5
                                    )
                                    .frame(width: 56, height: 56)
                                Text(icons[index])
                                    .font(.system(size: 22))
                            }
                            Text(label)
                                .font(Theme.typeFont(size: 8))
                                .foregroundStyle(selected == index ? Theme.tx2 : Theme.tx4)
                        }
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    AvatarPickerView()
        .preferredColorScheme(.light)
}
