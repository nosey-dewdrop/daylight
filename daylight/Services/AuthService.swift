import Foundation
import Observation
import Supabase

@Observable
final class AuthService {

    // MARK: - State

    var currentUser: AppUser?
    var isLoading = false
    var error: String?

    var isAuthenticated: Bool {
        currentUser != nil
    }

    // MARK: - Private

    private var authStateTask: Task<Void, Never>?

    // MARK: - Init

    init() {
        listenToAuthChanges()
    }

    deinit {
        authStateTask?.cancel()
    }

    // MARK: - Auth Methods

    func signUp(email: String, password: String) async throws {
        isLoading = true
        error = nil
        defer { isLoading = false }

        let response = try await supabase.auth.signUp(
            email: email,
            password: password
        )

        guard let userId = response.session?.user.id.uuidString else {
            throw AuthError.noSession
        }

        // Create the user profile row in the users table
        let newUser = AppUser(
            id: userId,
            locationVisible: false,
            languages: [],
            interests: [],
            xp: 0,
            level: 1,
            isPremium: false,
            onboardingComplete: false,
            createdAt: Date(),
            lastActiveAt: Date()
        )

        try await supabase
            .from("profiles")
            .insert(newUser)
            .execute()

        currentUser = newUser
    }

    func signIn(email: String, password: String) async throws {
        isLoading = true
        error = nil
        defer { isLoading = false }

        let session = try await supabase.auth.signIn(
            email: email,
            password: password
        )

        try await fetchAndSetUser(id: session.user.id.uuidString)
    }

    func signOut() async throws {
        try await supabase.auth.signOut()
        currentUser = nil
    }

    /// Attempt to restore an existing session on app launch
    func restoreSession() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let session = try await supabase.auth.session
            try await fetchAndSetUser(id: session.user.id.uuidString)
        } catch {
            // No valid session — user needs to sign in
            currentUser = nil
        }
    }

    // MARK: - Private Helpers

    private func fetchAndSetUser(id: String) async throws {
        let user: AppUser = try await supabase
            .from("profiles")
            .select()
            .eq("id", value: id)
            .single()
            .execute()
            .value

        currentUser = user
    }

    private func listenToAuthChanges() {
        authStateTask = Task { [weak self] in
            await supabase.auth.onAuthStateChange { event, session in
                guard let self else { return }

                switch event {
                case .signedIn:
                    if let userId = session?.user.id.uuidString {
                        Task {
                            try? await self.fetchAndSetUser(id: userId)
                        }
                    }
                case .signedOut:
                    Task { @MainActor in
                        self.currentUser = nil
                    }
                default:
                    break
                }
            }
        }
    }
}

// MARK: - Errors

enum AuthError: LocalizedError {
    case noSession
    case userNotFound

    var errorDescription: String? {
        switch self {
        case .noSession:
            return "No session returned after sign up. Please try again."
        case .userNotFound:
            return "User profile not found."
        }
    }
}
