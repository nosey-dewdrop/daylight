import SwiftUI

struct WaxSeal: View {
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            // Wax blob with irregular edges
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "#E74C3C"),
                            Color(hex: "#C0392B"),
                            Color(hex: "#96281B")
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 1)

            // Inner circle highlight
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: size * 0.6, height: size * 0.6)
                .offset(x: -size * 0.08, y: -size * 0.08)

            // D for Daylight embossed
            Text("D")
                .font(.system(size: size * 0.4, weight: .bold, design: .serif))
                .foregroundColor(Color(hex: "#96281B").opacity(0.6))
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        WaxSeal(size: 30)
        WaxSeal(size: 40)
        WaxSeal(size: 60)
    }
    .padding()
    .background(DaylightTheme.parchment)
}
