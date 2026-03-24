import SwiftUI

@main
struct daylightApp: App {
    @State private var authService = AuthService()
    @State private var letterService = LetterService()
    @State private var userService = UserService()
    @State private var stampService = StampService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authService)
                .environment(letterService)
                .environment(userService)
                .environment(stampService)
        }
    }
}
