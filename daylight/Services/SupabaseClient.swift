import Foundation
import Supabase

let supabase: SupabaseClient = {
    guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
          let config = NSDictionary(contentsOfFile: path),
          let urlString = config["supabaseURL"] as? String,
          let anonKey = config["supabaseAnonKey"] as? String,
          let url = URL(string: urlString) else {
        fatalError("Missing or invalid Config.plist. Ensure Config.plist exists in the app bundle with supabaseURL and supabaseAnonKey keys.")
    }

    return SupabaseClient(
        supabaseURL: url,
        supabaseKey: anonKey
    )
}()
