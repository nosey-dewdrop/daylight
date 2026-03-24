import SwiftUI

struct ContentView: View {
    @Environment(AuthService.self) private var auth

    var body: some View {
        Group {
            if auth.isLoading {
                // Splash / loading
                ZStack {
                    Theme.bg.ignoresSafeArea()
                    VStack(spacing: 6) {
                        Text("daylight")
                            .font(Theme.typeFont(size: 28))
                            .foregroundStyle(Theme.txt)
                            .tracking(6)
                        Text("letters that travel")
                            .font(Theme.typeFont(size: 10))
                            .foregroundStyle(Theme.tx4)
                            .tracking(3)
                    }
                }
            } else if !auth.isAuthenticated {
                LoginView()
            } else if let user = auth.currentUser, !user.onboardingComplete {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: auth.isAuthenticated)
        .animation(.easeInOut(duration: 0.3), value: auth.currentUser?.onboardingComplete)
        .task {
            await auth.restoreSession()
        }
    }
}
