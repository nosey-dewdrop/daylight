import SwiftUI

struct DraftsView: View {
    @Environment(AuthService.self) private var authService
    @Environment(LetterService.self) private var letterService
    @State private var selectedDraft: Letter?

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                if letterService.drafts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 50))
                            .foregroundColor(DaylightTheme.babyBlue)

                        Text("No drafts")
                            .font(DaylightTheme.headlineFont)
                            .foregroundColor(DaylightTheme.darkBrown)

                        Text("Letters you save as drafts will appear here")
                            .font(DaylightTheme.letterFont)
                            .foregroundColor(DaylightTheme.warmBrown)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(letterService.drafts) { draft in
                                draftCard(draft: draft)
                                    .onTapGesture {
                                        selectedDraft = draft
                                    }
                            }
                        }
                        .padding(DaylightTheme.padding)
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Drafts")
                        .font(DaylightTheme.titleFont)
                        .foregroundColor(DaylightTheme.darkBrown)
                }
            }
            .sheet(item: $selectedDraft) { draft in
                LetterDetailView(letter: draft)
            }
            .task {
                guard let userId = authService.currentUser?.id else { return }
                await letterService.fetchDrafts(userId: userId)
            }
        }
    }

    private func draftCard(draft: Letter) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(DaylightTheme.warmBrown)

                Text("To: \(draft.recipient?.displayName ?? "Unknown")")
                    .font(DaylightTheme.headlineFont)
                    .foregroundColor(DaylightTheme.darkBrown)

                Spacer()

                Button(action: {
                    Task {
                        await letterService.deleteDraft(letterId: draft.id)
                        guard let userId = authService.currentUser?.id else { return }
                        await letterService.fetchDrafts(userId: userId)
                    }
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 14))
                        .foregroundColor(DaylightTheme.waxRed.opacity(0.6))
                }
            }

            Text(draft.content.prefix(120) + (draft.content.count > 120 ? "..." : ""))
                .font(DaylightTheme.letterFont)
                .foregroundColor(DaylightTheme.inkBlack.opacity(0.6))
                .lineLimit(3)

            if let date = draft.createdAt {
                Text("Last edited \(date, style: .relative)")
                    .font(DaylightTheme.captionFont)
                    .foregroundColor(DaylightTheme.warmBrown.opacity(0.6))
            }
        }
        .padding(14)
        .parchmentCard()
    }
}
