import SwiftUI

struct SettingsView: View {
    @Environment(AuthService.self) private var authService
    @Environment(UserService.self) private var userService
    @Environment(\.dismiss) private var dismiss

    @State private var bio: String = ""
    @State private var isSaving = false
    @State private var showSignOutAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.cream
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Bio editing
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bio")
                                .font(DaylightTheme.headlineFont)
                                .foregroundColor(DaylightTheme.text)

                            TextEditor(text: $bio)
                                .font(DaylightTheme.letterFont)
                                .foregroundColor(DaylightTheme.inkBlack)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 100)
                                .padding(12)
                                .background(Color.white.opacity(0.6))
                                .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.smallCornerRadius))

                            Button(action: saveBio) {
                                Group {
                                    if isSaving {
                                        ProgressView().tint(.white)
                                    } else {
                                        Text("Save Bio")
                                    }
                                }
                                .daylightButton()
                            }
                            .disabled(isSaving)
                        }

                        Divider()

                        // Account info
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account")
                                .font(DaylightTheme.headlineFont)
                                .foregroundColor(DaylightTheme.text)

                            infoRow(title: "Email", value: authService.currentUser?.email ?? "-")
                            infoRow(title: "Member since", value: formattedJoinDate)
                            infoRow(title: "Level", value: "\(authService.currentProfile?.level ?? 1)")
                            infoRow(title: "XP", value: "\(authService.currentProfile?.xp ?? 0)")
                        }

                        Divider()

                        // App info
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About")
                                .font(DaylightTheme.headlineFont)
                                .foregroundColor(DaylightTheme.text)

                            infoRow(title: "Version", value: "1.0.0")
                            infoRow(title: "Made with", value: "love and patience")
                        }

                        Divider()

                        // Sign out
                        Button(action: { showSignOutAlert = true }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Sign Out")
                            }
                            .font(DaylightTheme.bodyFont)
                            .foregroundColor(DaylightTheme.waxRed)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(DaylightTheme.waxRed.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius))
                        }

                        Spacer().frame(height: 40)
                    }
                    .padding(DaylightTheme.padding)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(DaylightTheme.rose)
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Sign Out", role: .destructive) {
                    Task {
                        try? await authService.signOut()
                        dismiss()
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .onAppear {
                bio = authService.currentProfile?.bio ?? ""
            }
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(DaylightTheme.bodyFont)
                .foregroundColor(DaylightTheme.textSub)
            Spacer()
            Text(value)
                .font(DaylightTheme.bodyFont)
                .foregroundColor(DaylightTheme.text)
        }
        .padding(10)
        .background(Color.white.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.smallCornerRadius))
    }

    private var formattedJoinDate: String {
        guard let date = authService.currentProfile?.createdAt else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func saveBio() {
        guard let userId = authService.currentUser?.id else { return }
        isSaving = true
        let update = ProfileUpdate(bio: bio)
        Task {
            do {
                try await userService.updateProfile(update, userId: userId)
                await authService.refreshProfile()
            } catch {
                print("Save bio error: \(error)")
            }
            isSaving = false
        }
    }
}
