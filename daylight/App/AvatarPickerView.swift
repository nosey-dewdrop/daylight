import SwiftUI

struct AvatarPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var config = AvatarConfig.default

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
                        dismiss()
                    } label: {
                        Text("save")
                            .font(Theme.typeFont(size: 14))
                            .foregroundStyle(Theme.lilac)
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.vertical, 14)

                // Big avatar preview
                ZStack {
                    Circle()
                        .fill(Theme.bg2)
                        .frame(width: 220, height: 220)
                    Circle()
                        .strokeBorder(Theme.brd2, lineWidth: 1)
                        .frame(width: 220, height: 220)

                    AvatarView(
                        config: config,
                        size: 180,
                        bgColor: .clear,
                        showBackground: false
                    )
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
                                                    // Show this hair with current skin
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
                                                // Show current hair with this skin
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
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    AvatarPickerView()
        .preferredColorScheme(.light)
}
