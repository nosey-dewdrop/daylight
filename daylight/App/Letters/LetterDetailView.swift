import SwiftUI

struct LetterDetailView: View {
    let letter: Letter

    @Environment(AuthService.self) private var auth
    @Environment(\.dismiss) private var dismiss

    @State private var showReply = false
    @State private var markedAsRead = false

    private let letterService = LetterService()

    private var senderName: String {
        letter.sender?.displayName ?? "pen pal"
    }

    private var senderConfig: AvatarConfig {
        letter.sender?.avatarConfig ?? .default
    }

    private var timeText: String {
        if letter.status == .inTransit, let deliversAt = letter.deliversAt {
            let formatter = ISO8601DateFormatter()
            return Distance.timeLeft(deliversAt: formatter.string(from: deliversAt))
        } else if let sentAt = letter.sentAt {
            return Distance.formatDate(ISO8601DateFormatter().string(from: sentAt))
        }
        return ""
    }

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    // Sender info -- passport style avatar
                    HStack(spacing: 12) {
                        // Passport photo style avatar
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Theme.bg1)
                                .frame(width: 48, height: 56)
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(Theme.brd, lineWidth: 0.5)
                                .frame(width: 48, height: 56)
                            AvatarView(config: senderConfig, size: 40, showBackground: false)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(senderName)
                                .font(Theme.typeFont(size: 16))
                                .foregroundStyle(Theme.txt)
                                .fontWeight(.medium)

                            HStack(spacing: 6) {
                                StatusBadge(status: letter.status)
                                if let km = letter.distanceKm {
                                    Text(".")
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

                                // Letter text
                                Text(letter.content)
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

                        // Stamp on the paper (top-right, rectangular)
                        ZStack {
                            StampShape()
                                .fill(Color(hex: "F5F0E8"))
                                .frame(width: 40, height: 50)
                            StampShape()
                                .strokeBorder(Theme.brd.opacity(0.3), lineWidth: 0.5)
                                .frame(width: 40, height: 50)
                            if let stampName = letter.stamp?.imageName {
                                Image(stampName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                    }
                    .padding(.horizontal, Theme.padding)

                    // Delivery info
                    HStack {
                        if let hours = letter.deliveryHours {
                            Text("travel time: \(String(format: "%.1f", hours))h")
                                .font(Theme.typeFont(size: 9))
                                .foregroundStyle(Theme.tx4)
                                .italic()
                        }
                        Spacer()
                        Text(timeText)
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .italic()
                    }
                    .padding(.horizontal, Theme.padding)

                    // Reply button (only for inbox letters that are delivered/read)
                    if letter.status == .delivered || letter.status == .read,
                       letter.recipientId == auth.currentUser?.id {
                        Button {
                            showReply = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrowshape.turn.up.left")
                                    .font(.system(size: 12))
                                Text("reply")
                                    .font(Theme.typeFont(size: 13))
                            }
                            .foregroundStyle(Theme.bg)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Theme.lilac)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.horizontal, Theme.padding)
                    }
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
        .sheet(isPresented: $showReply) {
            if let senderId = letter.senderId {
                ComposeView(recipientId: senderId, recipientName: senderName)
                    .environment(auth)
            }
        }
        .task {
            // Mark as read on appear if it's delivered and addressed to current user
            if letter.status == .delivered,
               letter.recipientId == auth.currentUser?.id,
               let letterId = letter.id,
               !markedAsRead {
                markedAsRead = true
                try? await letterService.markAsRead(letterId: letterId)
            }
        }
    }
}
