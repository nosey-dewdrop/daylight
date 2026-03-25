import SwiftUI

struct HomeView: View {
    @Environment(AuthService.self) private var authService
    @Environment(LetterService.self) private var letterService
    @State private var showCompose = false
    @State private var selectedLetter: Letter?

    private var hasUnreadLetters: Bool {
        letterService.inboxLetters.contains { $0.status == .delivered }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Globe with in-transit letters
                        VStack(spacing: 12) {
                            Text("Letters on their way")
                                .font(DaylightTheme.headlineFont)
                                .foregroundColor(DaylightTheme.text)

                            GlobeView(inTransitLetters: letterService.inTransitLetters)
                                .frame(height: 260)

                            if letterService.inTransitLetters.isEmpty {
                                Text("No letters in transit right now")
                                    .font(DaylightTheme.letterFont)
                                    .foregroundColor(DaylightTheme.textSub.opacity(0.6))
                            } else {
                                Text("\(letterService.inTransitLetters.count) letter\(letterService.inTransitLetters.count == 1 ? "" : "s") flying to you")
                                    .font(DaylightTheme.captionFont)
                                    .foregroundColor(DaylightTheme.rose)
                            }
                        }
                        .padding(.top, 8)

                        // Inbox section
                        if !letterService.inboxLetters.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Your Letters")
                                        .font(DaylightTheme.titleFont)
                                        .foregroundColor(DaylightTheme.text)

                                    Spacer()

                                    if hasUnreadLetters {
                                        StatusBadge(status: .unread)
                                    }
                                }
                                .padding(.horizontal, DaylightTheme.padding)

                                LazyVStack(spacing: 0) {
                                    ForEach(letterService.inboxLetters) { letter in
                                        EnvelopeCard(
                                            letter: letter,
                                            senderName: letter.sender?.displayName ?? "Unknown",
                                            senderAvatar: letter.sender?.avatarConfig
                                        ) {
                                            selectedLetter = letter
                                        }
                                        .padding(.horizontal, DaylightTheme.padding)
                                    }
                                }
                            }
                        } else if !letterService.isLoading {
                            // Empty state
                            VStack(spacing: 16) {
                                Image(systemName: "envelope.open")
                                    .font(.system(size: 50))
                                    .foregroundColor(DaylightTheme.blue)

                                Text("Your mailbox is empty")
                                    .font(DaylightTheme.headlineFont)
                                    .foregroundColor(DaylightTheme.text)

                                Text("Send a letter or try bottle mail to start a conversation!")
                                    .font(DaylightTheme.letterFont)
                                    .foregroundColor(DaylightTheme.textSub)
                                    .multilineTextAlignment(.center)

                                Button(action: { showCompose = true }) {
                                    Label("Write a Letter", systemImage: "pencil.line")
                                        .daylightButton()
                                }
                                .padding(.horizontal, 60)
                            }
                            .padding(.vertical, 40)
                        }

                        Spacer().frame(height: 20)
                    }
                }

                // FAB for compose
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showCompose = true }) {
                            ZStack {
                                Circle()
                                    .fill(DaylightTheme.rose)
                                    .frame(width: 56, height: 56)
                                    .shadow(color: DaylightTheme.rose.opacity(0.4), radius: 8, x: 0, y: 4)

                                Image(systemName: "pencil.line")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("daylight")
                        .font(.system(size: 22, weight: .light, design: .serif))
                        .foregroundColor(DaylightTheme.text)
                }
            }
            .sheet(isPresented: $showCompose) {
                ComposeView()
            }
            .sheet(item: $selectedLetter) { letter in
                LetterDetailView(letter: letter)
            }
            .task {
                await loadData()
            }
            .refreshable {
                await loadData()
            }
        }
    }

    private func loadData() async {
        guard let userId = authService.currentUser?.id else { return }
        await letterService.fetchInbox(userId: userId)
        await letterService.fetchInTransit(userId: userId)
    }
}
