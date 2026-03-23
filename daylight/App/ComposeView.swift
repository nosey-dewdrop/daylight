import SwiftUI

struct ComposeView: View {
    @State private var letterContent = ""
    @FocusState private var isWriting: Bool

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
                    // Header
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
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                    // Paper writing area with stamp ON the paper
                    ZStack(alignment: .topTrailing) {
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

                        // Stamp on the paper (top-right of paper)
                        StampShape()
                            .fill(Color(hex: "F5F0E8"))
                            .frame(width: 44, height: 54)
                            .overlay(
                                StampShape()
                                    .strokeBorder(Theme.brd.opacity(0.3), lineWidth: 0.5)
                            )
                            .overlay(
                                Text("stamp")
                                    .font(Theme.typeFont(size: 6))
                                    .foregroundStyle(Theme.tx4)
                            )
                            .padding(.top, 8)
                            .padding(.trailing, 8)

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
                            .padding(.trailing, 60)
                            .padding(.top, 6)
                            .focused($isWriting)
                    }
                    .padding(.horizontal, Theme.padding)
                    .padding(.top, 4)

                    // Send button
                    Button {
                        // send action
                    } label: {
                        Text(canSend ? "send letter" : "\(minWords - wordCount) words to go")
                            .font(Theme.typeFont(size: 12))
                            .foregroundStyle(canSend ? Theme.bg : Theme.tx4)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(canSend ? Theme.lilac : Theme.bg2)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .disabled(!canSend)
                    .padding(.horizontal, Theme.padding)
                    .padding(.top, 8)
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
