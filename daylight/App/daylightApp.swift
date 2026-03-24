import SwiftUI

@main
struct DaylightApp: App {
    @State private var authService = AuthService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authService)
                .preferredColorScheme(.light)
        }
    }
}
