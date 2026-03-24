import SwiftUI

struct LoginView: View {
    @Environment(AuthService.self) private var auth

    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Branding
                VStack(spacing: 6) {
                    Text("daylight")
                        .font(Theme.typeFont(size: 32))
                        .foregroundStyle(Theme.txt)
                        .tracking(8)
                    Text("letters that travel")
                        .font(Theme.typeFont(size: 11))
                        .foregroundStyle(Theme.tx4)
                        .tracking(3)
                }
                .padding(.bottom, 48)

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

                    SecureField("", text: $password, prompt: Text("password").foregroundStyle(Theme.tx4))
                        .font(Theme.typeFont(size: 14))
                        .foregroundStyle(Theme.txt)
                        .textContentType(.password)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Theme.bg1)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Theme.brd, lineWidth: 0.5)
                        )
                }
                .padding(.horizontal, Theme.padding * 2)

                // Error
                if let errorMessage {
                    Text(errorMessage)
                        .font(Theme.typeFont(size: 10))
                        .foregroundStyle(Theme.pink)
                        .padding(.top, 8)
                }

                // Sign in button
                Button {
                    signIn()
                } label: {
                    Group {
                        if auth.isLoading {
                            ProgressView()
                                .tint(Theme.bg)
                        } else {
                            Text("sign in")
                                .font(Theme.typeFont(size: 14))
                        }
                    }
                    .foregroundStyle(Theme.bg)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.lilac)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(auth.isLoading || email.isEmpty || password.isEmpty)
                .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1)
                .padding(.horizontal, Theme.padding * 2)
                .padding(.top, 20)

                Spacer()

                // Create account
                Button {
                    showRegister = true
                } label: {
                    HStack(spacing: 4) {
                        Text("no account?")
                            .foregroundStyle(Theme.tx3)
                        Text("create one")
                            .foregroundStyle(Theme.lilac)
                    }
                    .font(Theme.typeFont(size: 12))
                }
                .padding(.bottom, 32)
            }
        }
        .fullScreenCover(isPresented: $showRegister) {
            RegisterView()
                .environment(auth)
        }
    }

    private func signIn() {
        errorMessage = nil
        Task {
            do {
                try await auth.signIn(email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
