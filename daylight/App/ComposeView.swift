import SwiftUI

struct ComposeView: View {
    @State private var letterContent = ""
    @State private var selectedStamp = 0
    @FocusState private var isWriting: Bool

    private let stamps = ["🌿", "🦋", "🌸", "✨", "🍂", "🌙", "☁️", "🕊️", "🌊", "🔮"]
    private let minWords = 300

    private var wordCount: Int {
        letterContent.split(separator: " ").count
    }

    private var canSend: Bool {
        wordCount >= minWords
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header — typewriter style
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("new letter")
                                .font(Theme.typeFont(size: 18))
                                .foregroundStyle(Theme.txt)
                            Text("\(wordCount) / \(minWords) words")
                                .font(Theme.typeFont(size: 10))
                                .foregroundStyle(canSend ? Theme.deliveredColor : Theme.tx4)
                        }

                        Spacer()

                        // Stamp in top-right corner
                        ZStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(hex: "D4DFE8"))
                                .frame(width: 44, height: 52)
                            RoundedRectangle(cornerRadius: 1)
                                .strokeBorder(Theme.tx4.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                                .frame(width: 38, height: 46)
                            Text(stamps[selectedStamp])
                                .font(.system(size: 22))
                        }
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                    // Paper writing area
                    ZStack {
                        // Parchment + ruled lines
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "F0EDE6"))
                            .overlay(
                                VStack(spacing: 28) {
                                    ForEach(0..<14, id: \.self) { _ in
                                        Rectangle()
                                            .fill(Theme.brd.opacity(0.3))
                                            .frame(height: 0.5)
                                    }
                                }
                                .padding(.top, 16)
                                .padding(.horizontal, 8)
                            )
                            .overlay(
                                HStack {
                                    Rectangle()
                                        .fill(Color(hex: "8B3A4A").opacity(0.15))
                                        .frame(width: 0.5)
                                        .padding(.leading, 28)
                                    Spacer()
                                }
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(Theme.brd.opacity(0.5), lineWidth: 0.5)
                            )

                        // Placeholder
                        if letterContent.isEmpty {
                            Text("dear friend,\n\nwrite something\nworth waiting for...")
                                .font(Theme.handFont(size: 18))
                                .foregroundStyle(Theme.tx4.opacity(0.5))
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(.top, 14)
                                .padding(.leading, 38)
                                .allowsHitTesting(false)
                        }

                        // Text editor
                        TextEditor(text: $letterContent)
                            .font(Theme.handFont(size: 18))
                            .foregroundStyle(Theme.txt)
                            .scrollContentBackground(.hidden)
                            .padding(.leading, 30)
                            .padding(.top, 6)
                            .focused($isWriting)
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.top, 4)

                    // Stamp selector
                    VStack(spacing: 6) {
                        HStack {
                            Text("STAMP")
                                .font(Theme.typeFont(size: 9))
                                .foregroundStyle(Theme.tx4)
                                .tracking(2)
                            Spacer()
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(Array(stamps.enumerated()), id: \.offset) { index, stamp in
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.15)) {
                                            selectedStamp = index
                                        }
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(selectedStamp == index ? Color(hex: "D4DFE8") : .clear)
                                                .frame(width: 36, height: 42)
                                            RoundedRectangle(cornerRadius: 1)
                                                .strokeBorder(
                                                    selectedStamp == index ? Theme.lilac.opacity(0.5) : Theme.brd,
                                                    style: StrokeStyle(lineWidth: 0.5, dash: selectedStamp == index ? [] : [2, 2])
                                                )
                                                .frame(width: 32, height: 38)
                                            Text(stamp)
                                                .font(.system(size: 18))
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.top, 8)
                    .padding(.bottom, 6)

                    // Send button
                    Button {
                        // send action
                    } label: {
                        HStack(spacing: 6) {
                            Text(stamps[selectedStamp])
                                .font(.system(size: 14))
                            Text(canSend ? "send letter" : "\(minWords - wordCount) words to go")
                                .font(Theme.typeFont(size: 12))
                        }
                        .foregroundStyle(canSend ? Theme.bg : Theme.tx4)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(canSend ? Theme.lilac : Theme.bg2)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .disabled(!canSend)
                    .padding(.horizontal, Theme.padding)
                    .padding(.bottom, Theme.padding)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("done") {
                        isWriting = false
                    }
                    .font(Theme.typeFont(size: 13))
                    .foregroundStyle(Theme.lilac)
                }
            }
        }
    }
}

#Preview {
    ComposeView()
        .preferredColorScheme(.light)
}
