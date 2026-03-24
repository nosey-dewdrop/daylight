import SwiftUI

struct WaxSeal: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "C4505E"), Color(hex: "8B3A4A")],
                        center: .center,
                        startRadius: 0,
                        endRadius: 10
                    )
                )
                .frame(width: 16, height: 16)
            Text("*")
                .font(.system(size: 7))
                .foregroundStyle(Color(hex: "E8909A"))
        }
    }
}
