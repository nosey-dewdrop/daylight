import SwiftUI

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
