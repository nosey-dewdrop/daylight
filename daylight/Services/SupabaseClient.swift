import Foundation
import Supabase

enum SupabaseManager {
    static let client: SupabaseClient = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let urlString = dict["SUPABASE_URL"] as? String,
              let anonKey = dict["SUPABASE_ANON_KEY"] as? String,
              let url = URL(string: urlString) else {
            fatalError("Config.plist missing or invalid. Ensure SUPABASE_URL and SUPABASE_ANON_KEY are set.")
        }

        return SupabaseClient(
            supabaseURL: url,
            supabaseKey: anonKey
        )
    }()
}
