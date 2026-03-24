import Foundation
import Supabase
import Auth

@Observable
final class AuthService {
    var currentUser: Auth.User?
    var currentProfile: Profile?
    var isAuthenticated = false
    var isLoading = true
    var errorMessage: String?

    private let client = SupabaseManager.client

    init() {
        Task { await restoreSession() }
        listenToAuthChanges()
    }

    private func listenToAuthChanges() {
        Task {
            for await (event, session) in client.auth.authStateChanges {
                await MainActor.run {
                    switch event {
                    case .signedIn:
                        self.currentUser = session?.user
                        self.isAuthenticated = true
                        if let userId = session?.user.id {
                            Task { await self.fetchProfile(userId: userId) }
                        }
                    case .signedOut:
                        self.currentUser = nil
                        self.currentProfile = nil
                        self.isAuthenticated = false
                    default:
                        break
                    }
                }
            }
        }
    }

    @MainActor
    func restoreSession() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let session = try await client.auth.session
            currentUser = session.user
            isAuthenticated = true
            await fetchProfile(userId: session.user.id)
        } catch {
            isAuthenticated = false
            currentUser = nil
        }
    }

    @MainActor
    func signUp(email: String, password: String) async throws {
        errorMessage = nil
        let response = try await client.auth.signUp(email: email, password: password)
        currentUser = response.user
        isAuthenticated = true
        await fetchProfile(userId: response.user.id)
    }

    @MainActor
    func signIn(email: String, password: String) async throws {
        errorMessage = nil
        let session = try await client.auth.signIn(email: email, password: password)
        currentUser = session.user
        isAuthenticated = true
        await fetchProfile(userId: session.user.id)
    }

    @MainActor
    func signOut() async throws {
        try await client.auth.signOut()
        currentUser = nil
        currentProfile = nil
        isAuthenticated = false
    }

    @MainActor
    func fetchProfile(userId: UUID) async {
        do {
            let profile: Profile = try await client
                .from("profiles")
                .select()
                .eq("id", value: userId.uuidString)
                .single()
                .execute()
                .value
            currentProfile = profile
        } catch {
            print("Failed to fetch profile: \(error)")
        }
    }

    @MainActor
    func refreshProfile() async {
        guard let userId = currentUser?.id else { return }
        await fetchProfile(userId: userId)
    }
}
