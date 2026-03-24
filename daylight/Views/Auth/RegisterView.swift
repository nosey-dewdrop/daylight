import SwiftUI

struct RegisterView: View {
    @Environment(AuthService.self) private var authService
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                DaylightTheme.skyGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Spacer().frame(height: 20)

                        VStack(spacing: 8) {
                            Image(systemName: "envelope.badge.person.crop")
                                .font(.system(size: 50))
                                .foregroundColor(DaylightTheme.deepBlue)

                            Text("Create Account")
                                .font(DaylightTheme.titleFont)
                                .foregroundColor(DaylightTheme.darkBrown)

                            Text("Start your pen pal journey")
                                .font(DaylightTheme.letterFont)
                                .foregroundColor(DaylightTheme.warmBrown)
                        }

                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Email")
                                    .font(DaylightTheme.captionFont)
                                    .foregroundColor(DaylightTheme.warmBrown)
                                TextField("your@email.com", text: $email)
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                    .font(DaylightTheme.bodyFont)
                                    .padding(12)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.smallCornerRadius))
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Password")
                                    .font(DaylightTheme.captionFont)
                                    .foregroundColor(DaylightTheme.warmBrown)
                                SecureField("Minimum 6 characters", text: $password)
                                    .textContentType(.newPassword)
                                    .font(DaylightTheme.bodyFont)
                                    .padding(12)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.smallCornerRadius))
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Confirm Password")
                                    .font(DaylightTheme.captionFont)
                                    .foregroundColor(DaylightTheme.warmBrown)
                                SecureField("Confirm password", text: $confirmPassword)
                                    .textContentType(.newPassword)
                                    .font(DaylightTheme.bodyFont)
                                    .padding(12)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.smallCornerRadius))
                            }

                            if let error = errorMessage {
                                Text(error)
                                    .font(DaylightTheme.captionFont)
                                    .foregroundColor(DaylightTheme.waxRed)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            Button(action: signUp) {
                                Group {
                                    if isLoading {
                                        ProgressView().tint(.white)
                                    } else {
                                        Text("Create Account")
                                    }
                                }
                                .daylightButton()
                            }
                            .disabled(isLoading || !isValid)
                        }
                        .padding(24)
                        .background(DaylightTheme.parchment.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius))
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 24)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(DaylightTheme.deepBlue)
                }
            }
        }
    }

    private var isValid: Bool {
        !email.isEmpty && password.count >= 6 && password == confirmPassword
    }

    private func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords don't match"
            return
        }
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await authService.signUp(email: email, password: password)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
