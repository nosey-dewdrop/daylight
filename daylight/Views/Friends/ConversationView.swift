import SwiftUI

struct ConversationView: View {
    let friend: Profile
    @Environment(AuthService.self) private var authService
    @Environment(LetterService.self) private var letterService
    @Environment(\.dismiss) private var dismiss
    @State private var showCompose = false
    @State private var selectedLetter: Letter?

    private var conversationLetters: [Letter] {
        let all = letterService.inboxLetters + letterService.sentLetters
        return all.filter { letter in
            (letter.senderId == friend.id || letter.recipientId == friend.id)
        }.sorted { ($0.sentAt ?? .distantPast) > ($1.sentAt ?? .distantPast) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Friend header
                        VStack(spacing: 12) {
                            AvatarView(config: friend.avatarConfig ?? .default, size: 80)
                                .overlay(Circle().stroke(DaylightTheme.warmBrown.opacity(0.2), lineWidth: 1))

                            Text(friend.displayName ?? "Unknown")
                                .font(DaylightTheme.titleFont)
                                .foregroundColor(DaylightTheme.darkBrown)

                            if let country = friend.country,
                               let info = Countries.find(byName: country) {
                                Text("\(info.flag) \(country)")
                                    .font(DaylightTheme.bodyFont)
                                    .foregroundColor(DaylightTheme.warmBrown)
                            }

                            if let bio = friend.bio, !bio.isEmpty {
                                Text(bio)
                                    .font(DaylightTheme.letterFont)
                                    .foregroundColor(DaylightTheme.inkBlack.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }

                            // Interests
                            if let interests = friend.interests, !interests.isEmpty {
                                FlowLayout(spacing: 6) {
                                    ForEach(interests, id: \.self) { interest in
                                        InterestChip(text: interest)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 16)

                        Divider().padding(.horizontal, 20)

                        // Letters history
                        if conversationLetters.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "envelope")
                                    .font(.system(size: 30))
                                    .foregroundColor(DaylightTheme.babyBlue)

                                Text("No letters exchanged yet")
                                    .font(DaylightTheme.bodyFont)
                                    .foregroundColor(DaylightTheme.warmBrown)
                            }
                            .padding(.vertical, 40)
                        } else {
                            ForEach(conversationLetters) { letter in
                                LetterCardView(
                                    letter: letter,
                                    showSender: letter.senderId == friend.id
                                )
                                .padding(.horizontal, DaylightTheme.padding)
                                .onTapGesture {
                                    selectedLetter = letter
                                }
                            }
                        }

                        Spacer().frame(height: 80)
                    }
                }

                // Write button
                VStack {
                    Spacer()
                    Button(action: { showCompose = true }) {
                        Label("Write to \(friend.displayName ?? "them")", systemImage: "pencil.line")
                            .daylightButton()
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(DaylightTheme.deepBlue)
                }
            }
            .sheet(isPresented: $showCompose) {
                ComposeView(recipientId: friend.id, recipientName: friend.displayName)
            }
            .sheet(item: $selectedLetter) { letter in
                LetterDetailView(letter: letter)
            }
            .task {
                guard let userId = authService.currentUser?.id else { return }
                await letterService.fetchSent(userId: userId)
            }
        }
    }
}
