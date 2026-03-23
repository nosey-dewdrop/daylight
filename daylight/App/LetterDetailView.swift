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
                VStack(spacing: 16) {
                    // Sender info — passport style avatar
                    HStack(spacing: 12) {
                        // Passport photo style avatar
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Theme.bg1)
                                .frame(width: 48, height: 56)
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(Theme.brd, lineWidth: 0.5)
                                .frame(width: 48, height: 56)
                            AvatarView(config: .default, size: 40, showBackground: false)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(senderName)
                                .font(Theme.typeFont(size: 16))
                                .foregroundStyle(Theme.txt)
                                .fontWeight(.medium)

                            HStack(spacing: 6) {
                                StatusBadge(status: status)
                                if let km = distanceKm {
                                    Text("·")
                                        .font(.system(size: 8))
                                        .foregroundStyle(Theme.tx4)
                                    Text(String(format: "%.0f km", km))
                                        .font(Theme.typeFont(size: 9))
                                        .foregroundStyle(Theme.tx3)
                                        .italic()
                                }
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, Theme.padding)

                    // Letter paper with stamp ON it
                    ZStack(alignment: .topTrailing) {
                        // Paper
                        VStack(spacing: 0) {
                            ZStack(alignment: .topLeading) {
                                Rectangle()
                                    .fill(Color(hex: "F5F2EB"))
                                    .overlay(
                                        VStack(spacing: 24) {
                                            ForEach(0..<25, id: \.self) { _ in
                                                Rectangle()
                                                    .fill(Theme.brd.opacity(0.15))
                                                    .frame(height: 0.5)
                                            }
                                        }
                                        .padding(.top, 20)
                                        .padding(.horizontal, 12)
                                    )
                                    .overlay(
                                        HStack {
                                            Rectangle()
                                                .fill(Color(hex: "C4707F").opacity(0.10))
                                                .frame(width: 0.5)
                                                .padding(.leading, 28)
                                            Spacer()
                                        }
                                    )

                                // Letter text — smaller, elegant
                                Text(content)
                                    .font(Theme.handFont(size: 15))
                                    .foregroundStyle(Color(hex: "2A2A3A"))
                                    .lineSpacing(8)
                                    .padding(.top, 24)
                                    .padding(.leading, 36)
                                    .padding(.trailing, 56)
                                    .padding(.bottom, 40)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(Theme.brd.opacity(0.3), lineWidth: 0.5)
                        )
                        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)

                        // Stamp on the paper
                        StampShape()
                            .fill(Color(hex: "F5F0E8"))
                            .frame(width: 40, height: 50)
                            .overlay(
                                StampShape()
                                    .strokeBorder(Theme.brd.opacity(0.3), lineWidth: 0.5)
                            )
                            .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
                            .padding(.top, 10)
                            .padding(.trailing, 10)
                    }
                    .padding(.horizontal, Theme.padding)

                    // Timestamp
                    HStack {
                        Spacer()
                        Text(timeInfo)
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .italic()
                    }
                    .padding(.horizontal, Theme.padding)
                }
                .padding(.top, 8)
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
