import SwiftUI

struct GlobeView: View {
    let inTransitLetters: [Letter]
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // Globe background
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "#4A90A4").opacity(0.3),
                            Color(hex: "#7EB5D6").opacity(0.2),
                            Color(hex: "#A8D8EA").opacity(0.1)
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)

            // Globe grid lines
            globeGrid

            // Globe outline
            Circle()
                .stroke(DaylightTheme.rose.opacity(0.3), lineWidth: 1.5)
                .frame(width: 240, height: 240)

            // In-transit letter indicators
            ForEach(Array(inTransitLetters.prefix(5).enumerated()), id: \.element.id) { index, letter in
                letterDot(letter: letter, index: index)
            }

            // Center icon
            Image(systemName: "globe.americas.fill")
                .font(.system(size: 28))
                .foregroundColor(DaylightTheme.rose.opacity(0.4))
        }
        .onAppear {
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        .onDisappear {
            rotation = 0
        }
    }

    private var globeGrid: some View {
        ZStack {
            // Latitude lines
            ForEach(0..<5, id: \.self) { i in
                let yOffset = CGFloat(i - 2) * 40
                Ellipse()
                    .stroke(DaylightTheme.blue.opacity(0.15), lineWidth: 0.5)
                    .frame(width: 240 * cos(Double(i - 2) * 0.4), height: 20)
                    .offset(y: yOffset)
            }

            // Longitude lines
            ForEach(0..<4, id: \.self) { i in
                let angle = Double(i) * 45
                Ellipse()
                    .stroke(DaylightTheme.blue.opacity(0.15), lineWidth: 0.5)
                    .frame(width: 60, height: 240)
                    .rotationEffect(.degrees(angle + rotation * 0.05))
            }
        }
    }

    @ViewBuilder
    private func letterDot(letter: Letter, index: Int) -> some View {
        let angle = Double(index) * (2 * .pi / 5) + rotation * .pi / 180 * 0.1
        let radius: CGFloat = 80 + CGFloat(index * 10)
        let x = cos(angle) * Double(radius)
        let y = sin(angle) * Double(radius) * 0.6

        VStack(spacing: 2) {
            // Flying envelope
            Image(systemName: "envelope.fill")
                .font(.system(size: 14))
                .foregroundColor(DaylightTheme.softGold)
                .shadow(color: DaylightTheme.softGold.opacity(0.5), radius: 4)

            // Countdown
            Text(DistanceCalculator.formatCountdown(letter.timeUntilDelivery))
                .font(.system(size: 8, design: .serif))
                .foregroundColor(DaylightTheme.rose)
        }
        .offset(x: x, y: y)
    }
}

#Preview {
    GlobeView(inTransitLetters: [])
        .frame(height: 300)
        .background(DaylightTheme.cream)
}
