import Foundation
import Supabase

enum SupabaseManager {
    static let client: SupabaseClient = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let urlString = dict["SUPABASE_URL"] as? String,
              let anonKey = dict["SUPABASE_ANON_KEY"] as? String,
              let url = URL(string: urlString) else {
            assertionFailure("Config.plist missing or invalid. Ensure SUPABASE_URL and SUPABASE_ANON_KEY are set.")
            // Fallback: return a client with placeholder values so the app does not crash in production.
            // All network calls will fail gracefully via existing try/catch handlers.
            return SupabaseClient(
                supabaseURL: URL(string: "https://invalid.supabase.co")!,
                supabaseKey: "invalid"
            )
        }

        return SupabaseClient(
            supabaseURL: url,
            supabaseKey: anonKey
        )
    }()
}
