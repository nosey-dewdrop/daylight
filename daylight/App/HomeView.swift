import SwiftUI

struct HomeView: View {
    @State private var currentPage = 0

    private var pageCount: Int {
        (mockLetters.count + 3) / 4 // 4 letters per page
    }

    private func lettersForPage(_ page: Int) -> [MockLetter] {
        let start = page * 4
        let end = min(start + 4, mockLetters.count)
        guard start < mockLetters.count else { return [] }
        return Array(mockLetters[start..<end])
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 2) {
                        Text("daylight")
                            .font(Theme.typeFont(size: 20))
                            .foregroundStyle(Theme.txt)
                            .tracking(4)
                        Text("letters that travel")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.tx4)
                            .tracking(3)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                    // 4 scattered envelopes
                    GeometryReader { geo in
                        let letters = lettersForPage(currentPage)
                        let positions = envelopePositions(in: geo.size, count: letters.count)

                        ForEach(Array(letters.enumerated()), id: \.element.id) { index, letter in
                            NavigationLink {
                                LetterDetailView(
                                    senderName: letter.name,
                                    senderEmoji: letter.emoji,
                                    content: letter.fullContent,
                                    stampEmoji: letter.stamp,
                                    status: letter.status,
                                    distanceKm: letter.distance,
                                    timeInfo: letter.time
                                )
                            } label: {
                                LetterCardView(
                                    senderName: letter.name,
                                    senderEmoji: letter.emoji,
                                    stampEmoji: letter.stamp,
                                    status: letter.status,
                                    timeInfo: letter.time
                                )
                                .frame(width: positions[index].size)
                            }
                            .buttonStyle(.plain)
                            .position(positions[index].point)
                            .rotationEffect(.degrees(positions[index].rotation))
                        }
                    }

                    // Page dots
                    if pageCount > 1 {
                        HStack(spacing: 8) {
                            ForEach(0..<pageCount, id: \.self) { page in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentPage = page
                                    }
                                } label: {
                                    Circle()
                                        .fill(page == currentPage ? Theme.txt : Theme.brd)
                                        .frame(width: 6, height: 6)
                                }
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
            }
        }
    }
}

// MARK: - Envelope Positioning

private struct EnvelopePosition {
    let point: CGPoint
    let rotation: Double
    let size: CGFloat
}

private func envelopePositions(in size: CGSize, count: Int) -> [EnvelopePosition] {
    let w = size.width
    let h = size.height

    // 4 positions: scattered across the desk
    let all: [EnvelopePosition] = [
        EnvelopePosition(point: CGPoint(x: w * 0.30, y: h * 0.15), rotation: -6, size: w * 0.54),
        EnvelopePosition(point: CGPoint(x: w * 0.72, y: h * 0.22), rotation: 4, size: w * 0.52),
        EnvelopePosition(point: CGPoint(x: w * 0.30, y: h * 0.55), rotation: 3, size: w * 0.56),
        EnvelopePosition(point: CGPoint(x: w * 0.72, y: h * 0.62), rotation: -5, size: w * 0.52),
    ]

    return Array(all.prefix(count))
}

// MARK: - Mock Data

struct MockLetter: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let preview: String
    let fullContent: String
    let status: LetterStatus
    let stamp: String
    let distance: Double?
    let time: String
}

let mockLetters: [MockLetter] = [
    MockLetter(
        name: "luna",
        emoji: "🌙",
        preview: "i've been thinking about what you said about the stars...",
        fullContent: "i've been thinking about what you said about the stars. there's this poem by neruda that keeps coming back to me.\n\n\"i want to do with you what spring does with the cherry trees.\"\n\ndo you ever feel like some words were written just for a specific moment in your life? i read that line three years ago and felt nothing. now it won't leave me alone.\n\nthe sky here has been impossibly clear. i counted seven shooting stars last night. made a wish on each one — same wish, seven times, just to be sure.\n\nyours,\nluna",
        status: .inTransit,
        stamp: "🌿",
        distance: 4200,
        time: "~3h left"
    ),
    MockLetter(
        name: "sol",
        emoji: "☀️",
        preview: "do you remember that café in lisbon?",
        fullContent: "do you remember that café in lisbon? the one with the blue tiles and the old man who played fado every evening. i went back last week.\n\nthe old man wasn't there anymore. but someone had left a note on his chair — \"obrigado pela música.\" i almost cried.\n\ni ordered the same coffee we had. it tasted different without you across the table. not worse, just... different. like hearing a song you love in a different key.\n\ni hope you're well. i hope your mornings are soft.\n\nwith warmth,\nsol",
        status: .delivered,
        stamp: "🦋",
        distance: 1800,
        time: "arrived 2h ago"
    ),
    MockLetter(
        name: "nyx",
        emoji: "🌑",
        preview: "i found a pressed flower in the book you recommended...",
        fullContent: "i found a pressed flower in the book you recommended. lavender, i think. it still smells faintly of summer.\n\nwho left it there? was it you? or some stranger who loved the same passage i did — page 47, where she says \"we are all just walking each other home.\"\n\ni've been reading a lot lately. mostly at night. the house gets so quiet after midnight that i can hear the pages turn like whispers.\n\ntell me what you're reading. tell me anything.\n\nalways,\nnyx",
        status: .read,
        stamp: "🌸",
        distance: 7300,
        time: "mar 12"
    ),
    MockLetter(
        name: "iris",
        emoji: "🌈",
        preview: "sometimes i write letters i never send...",
        fullContent: "sometimes i write letters i never send. do you think the words still matter if no one reads them?\n\ni have a drawer full of them. letters to people i've lost, people i miss, people i never got to say goodbye to. some are angry. some are soft. most are just... honest.\n\nmaybe that's what this app is for. a place where slow words can find slow people.\n\ni'm glad i found you here.\n\nwith quiet hope,\niris",
        status: .inTransit,
        stamp: "✨",
        distance: 2100,
        time: "~8h left"
    ),
    MockLetter(
        name: "elm",
        emoji: "🌳",
        preview: "the northern lights were out last night...",
        fullContent: "the northern lights were out last night. i stood there for an hour, just breathing. thought of you.\n\nthere's something about cold air and green light that makes everything feel both enormous and intimate at the same time. like the sky is telling you a secret.\n\ni took a photo but deleted it. some things shouldn't be captured. they should just be felt.\n\ni'll try to describe the color: imagine if silence had a color. that's what it looked like.\n\nmiss you,\nelm",
        status: .delivered,
        stamp: "🍂",
        distance: 5600,
        time: "arrived yesterday"
    ),
]

#Preview {
    HomeView()
        .preferredColorScheme(.light)
}
