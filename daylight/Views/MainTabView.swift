import SwiftUI

struct MainTabView: View {
    @Environment(AuthService.self) private var authService
    @Environment(LetterService.self) private var letterService
    @Environment(StampService.self) private var stampService
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "envelope.fill")
                }
                .tag(0)

            FriendsView()
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }
                .tag(1)

            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "globe.americas.fill")
                }
                .tag(2)

            DraftsView()
                .tabItem {
                    Label("Drafts", systemImage: "doc.text.fill")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(4)
        }
        .tint(DaylightTheme.rose)
        .task {
            await stampService.fetchAllStamps()
            if let userId = authService.currentUser?.id {
                await stampService.fetchUserStamps(userId: userId)
                await letterService.subscribeToLetters(userId: userId)
            }
        }
    }
}
