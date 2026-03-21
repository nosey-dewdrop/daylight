import SwiftUI

struct ContentView: View {
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
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "envelope")
                    Text("letters")
                }

            ComposeView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("write")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("profile")
                }
        }
        .tint(Theme.txt)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}
