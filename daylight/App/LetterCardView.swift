import SwiftUI

struct LetterCardView: View {
    let senderName: String
    let senderEmoji: String
    let stampEmoji: String
    let status: LetterStatus
    let timeInfo: String

    var body: some View {
        VStack(spacing: 6) {
            // Envelope with stamp ON TOP
            ZStack {
                Image("envelope")
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                // Stamp centered on envelope — prominent on top
                ZStack {
                    StampShape()
                        .fill(Color(hex: "F8F5EE"))
                        .frame(width: 44, height: 52)
                    StampShape()
                        .strokeBorder(Theme.brd.opacity(0.3), lineWidth: 0.5)
                        .frame(width: 44, height: 52)
                    Text(stampEmoji)
                        .font(.system(size: 26))
                }
                .offset(y: -8)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 1, y: 2)

                // Wax seal for delivered
                if status == .delivered {
                    WaxSeal()
                        .offset(y: 20)
                }
            }

            // Sender name below
            HStack(spacing: 4) {
                Text(senderEmoji)
                    .font(.system(size: 14))
                Text(senderName)
                    .font(Theme.handFont(size: 16))
                    .foregroundStyle(Theme.txt)
            }

            // Status
            HStack(spacing: 4) {
                StatusBadge(status: status)
                if status == .inTransit {
                    JourneyDots()
                }
            }
        }
        .shadow(color: .black.opacity(0.08), radius: 6, x: 2, y: 3)
    }
}

// MARK: - Stamp Shape (perforated edges)

struct StampShape: InsettableShape {
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let notchSize: CGFloat = 1.5
        let notchSpacing: CGFloat = 4.0
        var path = Path()

        path.move(to: CGPoint(x: r.minX, y: r.minY))
        var x = r.minX + notchSpacing
        while x < r.maxX - notchSpacing {
            path.addLine(to: CGPoint(x: x, y: r.minY))
            path.addArc(center: CGPoint(x: x + notchSize, y: r.minY),
                        radius: notchSize, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: true)
            x += notchSpacing
        }
        path.addLine(to: CGPoint(x: r.maxX, y: r.minY))

        var y = r.minY + notchSpacing
        while y < r.maxY - notchSpacing {
            path.addLine(to: CGPoint(x: r.maxX, y: y))
            path.addArc(center: CGPoint(x: r.maxX, y: y + notchSize),
                        radius: notchSize, startAngle: .degrees(270), endAngle: .degrees(90), clockwise: true)
            y += notchSpacing
        }
        path.addLine(to: CGPoint(x: r.maxX, y: r.maxY))

        x = r.maxX - notchSpacing
        while x > r.minX + notchSpacing {
            path.addLine(to: CGPoint(x: x, y: r.maxY))
            path.addArc(center: CGPoint(x: x - notchSize, y: r.maxY),
                        radius: notchSize, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
            x -= notchSpacing
        }
        path.addLine(to: CGPoint(x: r.minX, y: r.maxY))

        y = r.maxY - notchSpacing
        while y > r.minY + notchSpacing {
            path.addLine(to: CGPoint(x: r.minX, y: y))
            path.addArc(center: CGPoint(x: r.minX, y: y - notchSize),
                        radius: notchSize, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
            y -= notchSpacing
        }

        path.closeSubpath()
        return path
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}

// MARK: - Wax Seal

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
            Text("❋")
                .font(.system(size: 7))
                .foregroundStyle(Color(hex: "E8909A"))
        }
    }
}

// MARK: - Status & Journey

struct StatusBadge: View {
    let status: LetterStatus

    private var color: Color {
        switch status {
        case .inTransit, .draft: return Theme.transitColor
        case .delivered: return Theme.deliveredColor
        case .read, .expired, .memoryBox: return Theme.readColor
        }
    }

    var body: some View {
        HStack(spacing: 3) {
            Circle()
                .fill(color)
                .frame(width: 4, height: 4)
            Text(status.label)
                .font(Theme.typeFont(size: 8))
                .foregroundStyle(color)
        }
    }
}

struct JourneyDots: View {
    @State private var activeDot = 0
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Theme.transitColor)
                    .frame(width: 3, height: 3)
                    .opacity(i == activeDot ? 1.0 : 0.3)
            }
        }
        .animation(.none, value: activeDot)
        .onReceive(timer) { _ in
            activeDot = (activeDot + 1) % 3
        }
    }
}

#Preview {
    ZStack {
        Theme.bg.ignoresSafeArea()
        LetterCardView(
            senderName: "luna",
            senderEmoji: "🌙",
            stampEmoji: "🌿",
            status: .inTransit,
            timeInfo: "~3h left"
        )
        .frame(width: 160)
    }
    .preferredColorScheme(.light)
}
