import SwiftUI

struct ContentView: View {
    @Environment(AuthService.self) private var authService

    var body: some View {
        Group {
            if authService.isLoading {
                splashView
            } else if authService.isAuthenticated {
                if authService.currentProfile?.onboardingComplete == true {
                    MainTabView()
                } else {
                    OnboardingView()
                }
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authService.isAuthenticated)
        .animation(.easeInOut(duration: 0.3), value: authService.isLoading)
    }

    private var splashView: some View {
        ZStack {
            DaylightTheme.skyGradient
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Sun icon
                ZStack {
                    Circle()
                        .fill(DaylightTheme.softGold)
                        .frame(width: 80, height: 80)
                        .shadow(color: DaylightTheme.softGold.opacity(0.5), radius: 20)

                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }

                Text("daylight")
                    .font(.system(size: 36, weight: .light, design: .serif))
                    .foregroundColor(DaylightTheme.text)

                Text("letters that take their time")
                    .font(DaylightTheme.letterFont)
                    .foregroundColor(DaylightTheme.textSub)

                ProgressView()
                    .tint(DaylightTheme.textSub)
                    .padding(.top, 20)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthService())
        .environment(LetterService())
        .environment(UserService())
        .environment(StampService())
}
