import SwiftUI

struct ComposeView: View {
    @Environment(AuthService.self) private var auth

    // Optional pre-filled recipient (from reply or explore)
    var recipientId: String? = nil
    var recipientName: String? = nil

    @State private var letterContent = ""
    @State private var selectedRecipient: AppUser?
    @State private var selectedStamp: Stamp?
    @State private var showStampPicker = false
    @State private var showRecipientPicker = false
    @State private var isSending = false
    @State private var errorMessage: String?
    @State private var showSuccess = false
    @State private var estimatedDelivery: String?
    @State private var friends: [AppUser] = []

    @FocusState private var isWriting: Bool

    private let letterService = LetterService()
    private let userService = UserService()
    private let stampService = StampService()
    private let minWords = 50

    private var wordCount: Int {
        letterContent.split(separator: " ").count
    }

    private var canSend: Bool {
        wordCount >= minWords && (selectedRecipient != nil || recipientId != nil) && selectedStamp != nil
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("new letter")
                                .font(Theme.typeFont(size: 18))
                                .foregroundStyle(Theme.txt)
                            Text("\(wordCount) / \(minWords) words")
                                .font(Theme.typeFont(size: 10))
                                .foregroundStyle(canSend ? Theme.deliveredColor : Theme.tx4)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                    // Recipient selector
                    Button {
                        if recipientId == nil {
                            showRecipientPicker = true
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.tx3)

                            if let name = recipientName ?? selectedRecipient?.displayName {
                                Text("to: \(name)")
                                    .font(Theme.typeFont(size: 12))
                                    .foregroundStyle(Theme.txt)
                            } else {
                                Text("select recipient")
                                    .font(Theme.typeFont(size: 12))
                                    .foregroundStyle(Theme.tx4)
                            }

                            Spacer()

                            if let est = estimatedDelivery {
                                Text(est)
                                    .font(Theme.typeFont(size: 9))
                                    .foregroundStyle(Theme.transitColor)
                                    .italic()
                            }

                            if recipientId == nil {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Theme.tx4)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Theme.bg1)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Theme.brd, lineWidth: 0.5)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(recipientId != nil)
                    .padding(.horizontal, Theme.padding)
                    .padding(.bottom, 8)

                    // Paper writing area with stamp ON the paper
                    ZStack(alignment: .topTrailing) {
                        // Parchment + ruled lines
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "F0EDE6"))
                            .overlay(
                                VStack(spacing: 28) {
                                    ForEach(0..<14, id: \.self) { _ in
                                        Rectangle()
                                            .fill(Theme.brd.opacity(0.3))
                                            .frame(height: 0.5)
                                    }
                                }
                                .padding(.top, 16)
                                .padding(.horizontal, 8)
                            )
                            .overlay(
                                HStack {
                                    Rectangle()
                                        .fill(Color(hex: "8B3A4A").opacity(0.15))
                                        .frame(width: 0.5)
                                        .padding(.leading, 28)
                                    Spacer()
                                }
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(Theme.brd.opacity(0.5), lineWidth: 0.5)
                            )

                        // Stamp on the paper (top-right)
                        Button {
                            showStampPicker = true
                        } label: {
                            ZStack {
                                StampShape()
                                    .fill(Color(hex: "F5F0E8"))
                                    .frame(width: 44, height: 54)
                                StampShape()
                                    .strokeBorder(Theme.brd.opacity(0.3), lineWidth: 0.5)
                                    .frame(width: 44, height: 54)

                                if let stamp = selectedStamp {
                                    Image(stamp.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                } else {
                                    VStack(spacing: 2) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 10))
                                        Text("stamp")
                                            .font(Theme.typeFont(size: 6))
                                    }
                                    .foregroundStyle(Theme.tx4)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 8)
                        .padding(.trailing, 8)

                        // Placeholder
                        if letterContent.isEmpty {
                            Text("dear friend,\n\nwrite something\nworth waiting for...")
                                .font(Theme.handFont(size: 18))
                                .foregroundStyle(Theme.tx4.opacity(0.5))
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(.top, 14)
                                .padding(.leading, 38)
                                .allowsHitTesting(false)
                        }

                        // Text editor
                        TextEditor(text: $letterContent)
                            .font(Theme.handFont(size: 18))
                            .foregroundStyle(Theme.txt)
                            .scrollContentBackground(.hidden)
                            .padding(.leading, 30)
                            .padding(.trailing, 60)
                            .padding(.top, 6)
                            .focused($isWriting)
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.top, 4)

                    // Error
                    if let errorMessage {
                        Text(errorMessage)
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.pink)
                            .padding(.top, 4)
                    }

                    // Send button
                    Button {
                        sendLetter()
                    } label: {
                        Group {
                            if isSending {
                                ProgressView()
                                    .tint(Theme.bg)
                            } else if canSend {
                                Text("send letter")
                                    .font(Theme.typeFont(size: 12))
                            } else if wordCount < minWords {
                                Text("\(minWords - wordCount) words to go")
                                    .font(Theme.typeFont(size: 12))
                            } else if selectedRecipient == nil && recipientId == nil {
                                Text("select a recipient")
                                    .font(Theme.typeFont(size: 12))
                            } else {
                                Text("pick a stamp")
                                    .font(Theme.typeFont(size: 12))
                            }
                        }
                        .foregroundStyle(canSend ? Theme.bg : Theme.tx4)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(canSend ? Theme.lilac : Theme.bg2)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .disabled(!canSend || isSending)
                    .padding(.horizontal, Theme.padding)
                    .padding(.top, 8)
                    .padding(.bottom, Theme.padding)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("done") {
                        isWriting = false
                    }
                    .font(Theme.typeFont(size: 13))
                    .foregroundStyle(Theme.lilac)
                }
            }
            .sheet(isPresented: $showStampPicker) {
                StampPickerSheet(selectedStamp: $selectedStamp)
                    .environment(auth)
            }
            .sheet(isPresented: $showRecipientPicker) {
                RecipientPickerSheet(
                    selectedRecipient: $selectedRecipient,
                    onSelect: { recipient in
                        calculateDelivery(to: recipient)
                    }
                )
                .environment(auth)
            }
            .alert("letter sent!", isPresented: $showSuccess) {
                Button("ok") {
                    letterContent = ""
                    selectedStamp = nil
                    selectedRecipient = nil
                    estimatedDelivery = nil
                }
            } message: {
                Text("your letter is on its way")
            }
        }
    }

    // MARK: - Send

    private func sendLetter() {
        guard let senderId = auth.currentUser?.id else { return }
        let recipId = recipientId ?? selectedRecipient?.id
        guard let recipId else { return }

        isSending = true
        errorMessage = nil

        Task {
            do {
                _ = try await letterService.sendLetter(
                    senderId: senderId,
                    content: letterContent,
                    recipientId: recipId,
                    stampId: selectedStamp?.id,
                    songUrl: nil,
                    senderLat: auth.currentUser?.latitude,
                    senderLon: auth.currentUser?.longitude,
                    recipientLat: selectedRecipient?.latitude,
                    recipientLon: selectedRecipient?.longitude
                )
                await MainActor.run {
                    isSending = false
                    showSuccess = true
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isSending = false
                }
            }
        }
    }

    private func calculateDelivery(to recipient: AppUser) {
        guard let sLat = auth.currentUser?.latitude,
              let sLon = auth.currentUser?.longitude,
              let rLat = recipient.latitude,
              let rLon = recipient.longitude else {
            estimatedDelivery = "~30 min"
            return
        }
        let dist = Distance.haversine(lat1: sLat, lon1: sLon, lat2: rLat, lon2: rLon)
        let hours = Distance.deliveryHours(distanceKm: dist)
        if hours < 1 {
            estimatedDelivery = "~\(Int(hours * 60)) min"
        } else if hours < 24 {
            estimatedDelivery = "~\(Int(hours))h"
        } else {
            estimatedDelivery = "~\(Int(hours / 24)) days"
        }
    }
}

// MARK: - Stamp Picker Sheet

struct StampPickerSheet: View {
    @Environment(AuthService.self) private var auth
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedStamp: Stamp?

    @State private var userStamps: [Stamp] = []
    @State private var isLoading = true

    private let stampService = StampService()

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("pick a stamp")
                        .font(Theme.typeFont(size: 16))
                        .foregroundStyle(Theme.txt)
                        .tracking(2)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.tx3)
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.vertical, 14)

                if isLoading {
                    Spacer()
                    ProgressView()
                        .tint(Theme.lilac)
                    Spacer()
                } else if userStamps.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 28))
                            .foregroundStyle(Theme.tx4)
                        Text("no stamps unlocked yet")
                            .font(Theme.typeFont(size: 12))
                            .foregroundStyle(Theme.tx3)
                        Text("earn XP to unlock stamps")
                            .font(Theme.typeFont(size: 10))
                            .foregroundStyle(Theme.tx4)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                            ForEach(userStamps) { stamp in
                                let isSelected = selectedStamp?.id == stamp.id
                                Button {
                                    selectedStamp = stamp
                                    dismiss()
                                } label: {
                                    VStack(spacing: 4) {
                                        ZStack {
                                            StampShape()
                                                .fill(Color(hex: "F8F5EE"))
                                                .frame(width: 52, height: 64)
                                            StampShape()
                                                .strokeBorder(isSelected ? Theme.lilac : Theme.brd.opacity(0.3), lineWidth: isSelected ? 2 : 0.5)
                                                .frame(width: 52, height: 64)
                                            Image(stamp.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32, height: 32)
                                        }
                                        Text(stamp.name)
                                            .font(Theme.typeFont(size: 8))
                                            .foregroundStyle(Theme.tx3)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .task {
            guard let userId = auth.currentUser?.id else {
                isLoading = false
                return
            }
            do {
                userStamps = try await stampService.fetchUserStamps(userId: userId)
            } catch {
                // Silently fail; user sees empty state
            }
            isLoading = false
        }
    }
}

// MARK: - Recipient Picker Sheet

struct RecipientPickerSheet: View {
    @Environment(AuthService.self) private var auth
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedRecipient: AppUser?
    var onSelect: (AppUser) -> Void

    @State private var friends: [AppUser] = []
    @State private var isLoading = true

    private let userService = UserService()

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("choose recipient")
                        .font(Theme.typeFont(size: 16))
                        .foregroundStyle(Theme.txt)
                        .tracking(2)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.tx3)
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.vertical, 14)

                if isLoading {
                    Spacer()
                    ProgressView()
                        .tint(Theme.lilac)
                    Spacer()
                } else if friends.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 28))
                            .foregroundStyle(Theme.tx4)
                        Text("no pen pals yet")
                            .font(Theme.typeFont(size: 12))
                            .foregroundStyle(Theme.tx3)
                        Text("explore to find pen pals")
                            .font(Theme.typeFont(size: 10))
                            .foregroundStyle(Theme.tx4)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(friends) { friend in
                                Button {
                                    selectedRecipient = friend
                                    onSelect(friend)
                                    dismiss()
                                } label: {
                                    HStack(spacing: 12) {
                                        AvatarView(config: friend.avatarConfig ?? .default, size: 32, showBackground: true)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(friend.displayName ?? "pen pal")
                                                .font(Theme.typeFont(size: 13))
                                                .foregroundStyle(Theme.txt)
                                            if let country = friend.country {
                                                Text(country)
                                                    .font(Theme.typeFont(size: 9))
                                                    .foregroundStyle(Theme.tx3)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(Theme.bg1)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(Theme.brd, lineWidth: 0.5)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .task {
            guard let userId = auth.currentUser?.id else {
                isLoading = false
                return
            }
            do {
                // Search for users; in production this would be a friends list
                friends = try await userService.searchPenPals(
                    interests: auth.currentUser?.interests ?? [],
                    languages: auth.currentUser?.languages ?? [],
                    excludeIds: [userId]
                )
            } catch {
                // Silently fail
            }
            isLoading = false
        }
    }
}
