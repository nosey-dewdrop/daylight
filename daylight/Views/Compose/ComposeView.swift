import SwiftUI

struct ComposeView: View {
    var recipientId: UUID?
    var recipientName: String?
    var isBottleMail: Bool = false

    @Environment(AuthService.self) private var authService
    @Environment(LetterService.self) private var letterService
    @Environment(UserService.self) private var userService
    @Environment(StampService.self) private var stampService
    @Environment(\.dismiss) private var dismiss

    @State private var content = ""
    @State private var selectedStamp: Stamp?
    @State private var showStampPicker = false
    @State private var isSending = false
    @State private var errorMessage: String?
    @State private var recipientProfile: Profile?

    private var wordCount: Int {
        content.split(separator: " ").count
    }

    private var canSend: Bool {
        wordCount >= 50 && (recipientId != nil || isBottleMail)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Recipient info
                        recipientHeader

                        // Letter writing area (parchment style)
                        VStack(alignment: .leading, spacing: 12) {
                            // Stamp area
                            HStack {
                                Spacer()
                                Button(action: { showStampPicker = true }) {
                                    if let stamp = selectedStamp {
                                        StampView(stamp: stamp, width: 50)
                                    } else {
                                        VStack(spacing: 4) {
                                            RoundedRectangle(cornerRadius: 3)
                                                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                                .foregroundColor(DaylightTheme.warmBrown.opacity(0.5))
                                                .frame(width: 50, height: 65)
                                                .overlay(
                                                    Image(systemName: "plus")
                                                        .foregroundColor(DaylightTheme.warmBrown)
                                                )
                                            Text("Stamp")
                                                .font(.system(size: 10, design: .serif))
                                                .foregroundColor(DaylightTheme.warmBrown)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }

                            // Letter content
                            ZStack(alignment: .topLeading) {
                                if content.isEmpty {
                                    Text("Write your letter here...\n\nTake your time. Say something meaningful. Letters need at least 50 words.")
                                        .font(DaylightTheme.letterFont)
                                        .foregroundColor(DaylightTheme.warmBrown.opacity(0.4))
                                        .padding(4)
                                }

                                TextEditor(text: $content)
                                    .font(DaylightTheme.letterFont)
                                    .foregroundColor(DaylightTheme.inkBlack)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 300)
                            }

                            // Line separator
                            ForEach(0..<8, id: \.self) { _ in
                                Divider()
                                    .background(DaylightTheme.warmBrown.opacity(0.1))
                                    .padding(.vertical, 6)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius)
                                .fill(DaylightTheme.parchment)
                                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal, 16)

                        // Word count
                        HStack {
                            Text("\(wordCount) / 50 words minimum")
                                .font(DaylightTheme.captionFont)
                                .foregroundColor(wordCount >= 50 ? DaylightTheme.mutedGreen : DaylightTheme.warmBrown)

                            Spacer()

                            if let error = errorMessage {
                                Text(error)
                                    .font(DaylightTheme.captionFont)
                                    .foregroundColor(DaylightTheme.waxRed)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(DaylightTheme.deepBlue)
                }

                ToolbarItem(placement: .principal) {
                    Text(isBottleMail ? "Bottle Mail" : "Write Letter")
                        .font(DaylightTheme.headlineFont)
                        .foregroundColor(DaylightTheme.darkBrown)
                }

                ToolbarItem(placement: .primaryAction) {
                    Button(action: sendLetter) {
                        if isSending {
                            ProgressView()
                                .tint(DaylightTheme.deepBlue)
                        } else {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(canSend ? DaylightTheme.deepBlue : DaylightTheme.warmBrown.opacity(0.3))
                        }
                    }
                    .disabled(!canSend || isSending)
                }
            }
            .sheet(isPresented: $showStampPicker) {
                StampPickerView(selectedStamp: $selectedStamp)
            }
            .task {
                if let recipientId = recipientId {
                    recipientProfile = await userService.fetchProfile(userId: recipientId)
                }
            }
        }
    }

    private var recipientHeader: some View {
        HStack(spacing: 12) {
            if isBottleMail {
                ZStack {
                    Circle()
                        .fill(DaylightTheme.deepBlue.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "drop.fill")
                        .font(.system(size: 20))
                        .foregroundColor(DaylightTheme.deepBlue)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Bottle Mail")
                        .font(DaylightTheme.headlineFont)
                        .foregroundColor(DaylightTheme.darkBrown)
                    Text("Your letter will find a random reader")
                        .font(DaylightTheme.captionFont)
                        .foregroundColor(DaylightTheme.warmBrown)
                }
            } else if let profile = recipientProfile {
                AvatarView(config: profile.avatarConfig ?? .default, size: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text("To: \(profile.displayName ?? "Unknown")")
                        .font(DaylightTheme.headlineFont)
                        .foregroundColor(DaylightTheme.darkBrown)
                    if let country = profile.country {
                        Text(country)
                            .font(DaylightTheme.captionFont)
                            .foregroundColor(DaylightTheme.warmBrown)
                    }
                }
            } else if let name = recipientName {
                Text("To: \(name)")
                    .font(DaylightTheme.headlineFont)
                    .foregroundColor(DaylightTheme.darkBrown)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private func sendLetter() {
        guard let senderId = authService.currentUser?.id,
              let senderProfile = authService.currentProfile else { return }

        isSending = true
        errorMessage = nil

        Task {
            do {
                var targetId = recipientId
                var targetProfile = recipientProfile

                // For bottle mail, find a random recipient
                if isBottleMail {
                    if let randomPal = await userService.getRandomPenPal(excludeUserId: senderId) {
                        targetId = randomPal.id
                        targetProfile = randomPal
                    } else {
                        errorMessage = "No pen pals available for bottle mail"
                        isSending = false
                        return
                    }
                }

                guard let targetId = targetId else {
                    errorMessage = "No recipient selected"
                    isSending = false
                    return
                }

                let senderLat = senderProfile.latitude ?? 0
                let senderLng = senderProfile.longitude ?? 0
                let recipientLat = targetProfile?.latitude ?? 0
                let recipientLng = targetProfile?.longitude ?? 0

                try await letterService.sendLetter(
                    senderId: senderId,
                    recipientId: targetId,
                    content: content,
                    stampId: selectedStamp?.id,
                    senderLat: senderLat,
                    senderLng: senderLng,
                    recipientLat: recipientLat,
                    recipientLng: recipientLng,
                    isBottle: isBottleMail
                )

                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            isSending = false
        }
    }
}
