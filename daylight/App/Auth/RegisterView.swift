import SwiftUI

struct RegisterView: View {
    @Environment(AuthService.self) private var auth
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?

    private var passwordsMatch: Bool {
        !password.isEmpty && password == confirmPassword
    }

    private var canRegister: Bool {
        !email.isEmpty && password.count >= 6 && passwordsMatch
    }

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 12))
                            Text("back")
                                .font(Theme.typeFont(size: 12))
                        }
                        .foregroundStyle(Theme.tx2)
                    }
                    Spacer()
                }
                .padding(.horizontal, Theme.padding)
                .padding(.top, 16)

                Spacer()

                // Branding
                VStack(spacing: 6) {
                    Text("create account")
                        .font(Theme.typeFont(size: 24))
                        .foregroundStyle(Theme.txt)
                        .tracking(4)
                    Text("start your letter journey")
                        .font(Theme.typeFont(size: 10))
                        .foregroundStyle(Theme.tx4)
                        .tracking(2)
                }
                .padding(.bottom, 36)

                // Fields
                VStack(spacing: 14) {
                    TextField("", text: $email, prompt: Text("email").foregroundStyle(Theme.tx4))
                        .font(Theme.typeFont(size: 14))
                        .foregroundStyle(Theme.txt)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Theme.bg1)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Theme.brd, lineWidth: 0.5)
                        )

                    SecureField("", text: $password, prompt: Text("password (min 6 chars)").foregroundStyle(Theme.tx4))
                        .font(Theme.typeFont(size: 14))
                        .foregroundStyle(Theme.txt)
                        .textContentType(.newPassword)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Theme.bg1)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Theme.brd, lineWidth: 0.5)
                        )

                    SecureField("", text: $confirmPassword, prompt: Text("confirm password").foregroundStyle(Theme.tx4))
                        .font(Theme.typeFont(size: 14))
                        .foregroundStyle(Theme.txt)
                        .textContentType(.newPassword)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Theme.bg1)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(
                                    !confirmPassword.isEmpty && !passwordsMatch ? Theme.pink : Theme.brd,
                                    lineWidth: 0.5
                                )
                        )

                    if !confirmPassword.isEmpty && !passwordsMatch {
                        Text("passwords don't match")
                            .font(Theme.typeFont(size: 9))
                            .foregroundStyle(Theme.pink)
                    }
                }
                .padding(.horizontal, Theme.padding * 2)

                // Error
                if let errorMessage {
                    Text(errorMessage)
                        .font(Theme.typeFont(size: 10))
                        .foregroundStyle(Theme.pink)
                        .padding(.top, 8)
                        .padding(.horizontal, Theme.padding * 2)
                        .multilineTextAlignment(.center)
                }

                // Register button
                Button {
                    register()
                } label: {
                    Group {
                        if auth.isLoading {
                            ProgressView()
                                .tint(Theme.bg)
                        } else {
                            Text("create account")
                                .font(Theme.typeFont(size: 14))
                        }
                    }
                    .foregroundStyle(Theme.bg)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(canRegister ? Theme.lilac : Theme.bg3)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(!canRegister || auth.isLoading)
                .padding(.horizontal, Theme.padding * 2)
                .padding(.top, 20)

                Spacer()
            }
        }
    }

    private func register() {
        errorMessage = nil
        Task {
            do {
                try await auth.signUp(email: email, password: password)
                // On success, ContentView will detect authenticated + !onboardingComplete
                // and show OnboardingView
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
