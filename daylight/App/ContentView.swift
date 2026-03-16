import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 16) {
                Text("daylight")
                    .font(Theme.displayFont(size: 40))
                    .foregroundStyle(Theme.lilac)

                Text("letters that travel")
                    .font(Theme.bodyFont(size: 14))
                    .foregroundStyle(Theme.tx3)
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
