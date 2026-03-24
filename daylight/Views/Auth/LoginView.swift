import SwiftUI

struct LoginView: View {
    @Environment(AuthService.self) private var authService
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showRegister = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            DaylightTheme.skyGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    Spacer().frame(height: 60)

                    // Logo
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(DaylightTheme.softGold)
                                .frame(width: 80, height: 80)
                                .shadow(color: DaylightTheme.softGold.opacity(0.4), radius: 15)

                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }

                        Text("daylight")
                            .font(.system(size: 36, weight: .light, design: .serif))
                            .foregroundColor(DaylightTheme.text)

                        Text("letters that take their time")
                            .font(DaylightTheme.letterFont)
                            .foregroundColor(DaylightTheme.textSub)
                    }

                    // Login form
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(DaylightTheme.captionFont)
                                .foregroundColor(DaylightTheme.textSub)

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
                                .foregroundColor(DaylightTheme.textSub)

                            SecureField("Password", text: $password)
                                .textContentType(.password)
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

                        Button(action: signIn) {
                            Group {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Sign In")
                                }
                            }
                            .daylightButton()
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)

                        Button(action: { showRegister = true }) {
                            Text("Don't have an account? ")
                                .font(DaylightTheme.captionFont)
                                .foregroundColor(DaylightTheme.textSub)
                            + Text("Sign Up")
                                .font(DaylightTheme.captionFont)
                                .foregroundColor(DaylightTheme.rose)
                        }
                    }
                    .padding(24)
                    .background(DaylightTheme.parchment.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: DaylightTheme.cornerRadius))
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 24)
                }
            }
        }
        .sheet(isPresented: $showRegister) {
            RegisterView()
        }
    }

    private func signIn() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await authService.signIn(email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
