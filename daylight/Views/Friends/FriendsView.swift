import SwiftUI

struct FriendsView: View {
    @Environment(AuthService.self) private var authService
    @Environment(UserService.self) private var userService
    @Environment(LetterService.self) private var letterService
    @State private var selectedFriend: Profile?

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                if userService.friends.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(userService.friends) { friendship in
                                if let friend = friendship.friend {
                                    friendRow(friend: friend)
                                        .onTapGesture {
                                            selectedFriend = friend
                                        }
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
                    Text("Pen Pals")
                        .font(DaylightTheme.titleFont)
                        .foregroundColor(DaylightTheme.darkBrown)
                }
            }
            .sheet(item: $selectedFriend) { friend in
                ConversationView(friend: friend)
            }
            .task {
                guard let userId = authService.currentUser?.id else { return }
                await userService.fetchFriends(userId: userId)
            }
            .refreshable {
                guard let userId = authService.currentUser?.id else { return }
                await userService.fetchFriends(userId: userId)
            }
        }
    }

    private func friendRow(friend: Profile) -> some View {
        HStack(spacing: 14) {
            AvatarView(config: friend.avatarConfig ?? .default, size: 50)
                .overlay(Circle().stroke(DaylightTheme.warmBrown.opacity(0.2), lineWidth: 1))

            VStack(alignment: .leading, spacing: 4) {
                Text(friend.displayName ?? "Unknown")
                    .font(DaylightTheme.headlineFont)
                    .foregroundColor(DaylightTheme.darkBrown)

                HStack(spacing: 8) {
                    if let country = friend.country,
                       let info = Countries.find(byName: country) {
                        Text("\(info.flag) \(country)")
                            .font(DaylightTheme.captionFont)
                            .foregroundColor(DaylightTheme.warmBrown)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(DaylightTheme.warmBrown.opacity(0.5))
        }
        .padding(14)
        .parchmentCard()
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2")
                .font(.system(size: 50))
                .foregroundColor(DaylightTheme.babyBlue)

            Text("No pen pals yet")
                .font(DaylightTheme.headlineFont)
                .foregroundColor(DaylightTheme.darkBrown)

            Text("Go to Explore to find pen pals from around the world!")
                .font(DaylightTheme.letterFont)
                .foregroundColor(DaylightTheme.warmBrown)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
