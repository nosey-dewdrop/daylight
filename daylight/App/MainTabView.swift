import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Theme.bg)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Theme.tx4)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Theme.txt)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            LettersView()
                .tabItem {
                    Image(systemName: "envelope")
                    Text("letters")
                }
                .tag(0)

            ExploreView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("explore")
                }
                .tag(1)

            ComposeView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("write")
                }
                .tag(2)

            StampCollectionView()
                .tabItem {
                    Image(systemName: "star")
                    Text("stamps")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("profile")
                }
                .tag(4)
        }
        .tint(Theme.txt)
    }
}
