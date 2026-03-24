import SwiftUI

struct LettersView: View {
    @Environment(AuthService.self) private var auth

    @State private var inbox: [Letter] = []
    @State private var sent: [Letter] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedSection = 0

    private let letterService = LetterService()

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 2) {
                        Text("daylight")
                            .font(Theme.typeFont(size: 20))
                            .foregroundStyle(Theme.txt)
                            .tracking(4)
                        Text("letters that travel")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .tracking(3)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                    // Section picker
                    HStack(spacing: 0) {
                        sectionTab(title: "inbox", index: 0, count: inbox.count)
                        sectionTab(title: "sent", index: 1, count: sent.count)
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.bottom, 8)

                    // Content
                    if isLoading {
                        Spacer()
                        ProgressView()
                            .tint(Theme.lilac)
                        Spacer()
                    } else if selectedSection == 0 && inbox.isEmpty {
                        emptyState(message: "no letters yet", subtitle: "write your first one")
                    } else if selectedSection == 1 && sent.isEmpty {
                        emptyState(message: "no sent letters", subtitle: "compose a letter to get started")
                    } else {
                        let letters = selectedSection == 0 ? inbox : sent
                        letterList(letters: letters)
                    }
                }
            }
        }
        .task {
            await loadLetters()
        }
        .refreshable {
            await loadLetters()
        }
        .task {
            guard let userId = auth.currentUser?.id else { return }
            await letterService.subscribeToInbox(userId: userId) { newLetter in
                Task { @MainActor in
                    // Insert at the top if not already present
                    if !inbox.contains(where: { $0.id == newLetter.id }) {
                        inbox.insert(newLetter, at: 0)
                    }
                }
            }
        }
    }

    // MARK: - Section Tab

    private func sectionTab(title: String, index: Int, count: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedSection = index
            }
        } label: {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Text(title)
                        .font(Theme.typeFont(size: 12))
                        .foregroundStyle(selectedSection == index ? Theme.txt : Theme.tx3)
                    if count > 0 {
                        Text("\(count)")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.bg)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(selectedSection == index ? Theme.lilac : Theme.tx4)
                            .clipShape(Capsule())
                    }
                }
                Rectangle()
                    .fill(selectedSection == index ? Theme.txt : Color.clear)
                    .frame(height: 1)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Empty State

    private func emptyState(message: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Spacer()
            Image(systemName: "envelope.open")
                .font(.system(size: 32))
                .foregroundStyle(Theme.tx4)
            Text(message)
                .font(Theme.typeFont(size: 14))
                .foregroundStyle(Theme.tx3)
            Text(subtitle)
                .font(Theme.typeFont(size: 10))
                .foregroundStyle(Theme.tx4)
            Spacer()
        }
    }

    // MARK: - Letter List

    private func letterList(letters: [Letter]) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(letters) { letter in
                    NavigationLink {
                        LetterDetailView(letter: letter)
                    } label: {
                        LetterCardView(letter: letter, isInbox: selectedSection == 0)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Theme.padding)
            .padding(.top, 8)
            .padding(.bottom, 80)
        }
    }

    // MARK: - Data Loading

    private func loadLetters() async {
        guard let userId = auth.currentUser?.id else { return }
        isLoading = inbox.isEmpty && sent.isEmpty

        do {
            // Check for newly delivered letters first
            _ = try await letterService.fetchDeliveredLetters()

            async let inboxFetch = letterService.fetchInbox(userId: userId)
            async let sentFetch = letterService.fetchSent(userId: userId)

            let (fetchedInbox, fetchedSent) = try await (inboxFetch, sentFetch)

            await MainActor.run {
                inbox = fetchedInbox
                sent = fetchedSent
                isLoading = false
                errorMessage = nil
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}
