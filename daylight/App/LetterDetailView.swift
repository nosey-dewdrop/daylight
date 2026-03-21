import SwiftUI

struct LetterDetailView: View {
    let senderName: String
    let senderEmoji: String
    let content: String
    let stampEmoji: String
    let status: LetterStatus
    let distanceKm: Double?
    let timeInfo: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Envelope header
                    HStack {
                        AvatarView(emoji: senderEmoji, size: 40)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(senderName)
                                .font(Theme.typeFont(size: 14))
                                .foregroundStyle(Theme.txt)
                            HStack(spacing: 6) {
                                StatusBadge(status: status)
                                if let km = distanceKm {
                                    Text("·")
                                        .font(.system(size: 8))
                                        .foregroundStyle(Theme.tx4)
                                    Text("\(Int(km)) km")
                                        .font(Theme.typeFont(size: 10))
                                        .foregroundStyle(Theme.tx3)
                                }
                            }
                        }
                        Spacer()
                        // Stamp
                        ZStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Theme.bg2)
                                .frame(width: 40, height: 48)
                            RoundedRectangle(cornerRadius: 1)
                                .strokeBorder(Theme.brd.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                                .frame(width: 36, height: 44)
                            Text(stampEmoji)
                                .font(.system(size: 20))
                        }
                    }
                    .padding(Theme.padding)

                    // Letter paper
                    ZStack(alignment: .topLeading) {
                        // Paper background with ruled lines
                        Rectangle()
                            .fill(Color(hex: "F5F2EB"))
                            .overlay(
                                VStack(spacing: 28) {
                                    ForEach(0..<20, id: \.self) { _ in
                                        Rectangle()
                                            .fill(Theme.brd.opacity(0.2))
                                            .frame(height: 0.5)
                                    }
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 12)
                            )
                            .overlay(
                                HStack {
                                    Rectangle()
                                        .fill(Color(hex: "C4707F").opacity(0.12))
                                        .frame(width: 0.5)
                                        .padding(.leading, 32)
                                    Spacer()
                                }
                            )

                        // Letter text
                        Text(content)
                            .font(Theme.handFont(size: 20))
                            .foregroundStyle(Color(hex: "2A2A3A"))
                            .lineSpacing(10)
                            .padding(.top, 20)
                            .padding(.leading, 40)
                            .padding(.trailing, 20)
                            .padding(.bottom, 40)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Theme.brd.opacity(0.3), lineWidth: 0.5)
                    )
                    .padding(.horizontal, Theme.padding)
                    .shadow(color: .black.opacity(0.04), radius: 8, y: 4)

                    // Timestamp
                    Text(timeInfo)
                        .font(Theme.typeFont(size: 10))
                        .foregroundStyle(Theme.tx4)
                        .padding(.top, 16)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 12))
                        Text("back")
                            .font(Theme.typeFont(size: 12))
                    }
                    .foregroundStyle(Theme.tx2)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LetterDetailView(
            senderName: "luna",
            senderEmoji: "🌙",
            content: "i've been thinking about what you said about the stars. there's this poem by neruda that keeps coming back to me.\n\n\"i want to do with you what spring does with the cherry trees.\"\n\ndo you ever feel like some words were written just for a specific moment in your life? i read that line three years ago and felt nothing. now it won't leave me alone.\n\nthe sky here has been impossibly clear. i counted seven shooting stars last night. made a wish on each one — same wish, seven times, just to be sure.\n\nyours,\nluna",
            stampEmoji: "🌿",
            status: .delivered,
            distanceKm: 4200,
            timeInfo: "arrived 2h ago"
        )
    }
    .preferredColorScheme(.light)
}
