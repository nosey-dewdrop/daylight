import SwiftUI

struct StampPickerView: View {
    @Binding var selectedStamp: Stamp?
    @Environment(AuthService.self) private var authService
    @Environment(StampService.self) private var stampService
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        let grouped = stampService.stampsByCategory()
                        ForEach(Array(grouped.keys.sorted()), id: \.self) { category in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(category)
                                    .font(DaylightTheme.headlineFont)
                                    .foregroundColor(DaylightTheme.darkBrown)
                                    .padding(.horizontal, DaylightTheme.padding)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(grouped[category] ?? []) { stamp in
                                            let isUnlocked = stampService.isUnlocked(stamp) ||
                                                stamp.xpRequired == 0

                                            Button(action: {
                                                if isUnlocked {
                                                    selectedStamp = stamp
                                                    dismiss()
                                                }
                                            }) {
                                                VStack(spacing: 4) {
                                                    StampView(
                                                        stamp: stamp,
                                                        width: 65,
                                                        isUnlocked: isUnlocked
                                                    )

                                                    if selectedStamp?.id == stamp.id {
                                                        Circle()
                                                            .fill(DaylightTheme.deepBlue)
                                                            .frame(width: 8, height: 8)
                                                    }

                                                    if stamp.xpRequired > 0 {
                                                        Text("\(stamp.xpRequired) XP")
                                                            .font(.system(size: 9, design: .serif))
                                                            .foregroundColor(DaylightTheme.warmBrown)
                                                    }
                                                }
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.horizontal, DaylightTheme.padding)
                                }
                            }
                        }

                        Spacer().frame(height: 20)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Choose a Stamp")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(DaylightTheme.deepBlue)
                }
            }
        }
    }
}
