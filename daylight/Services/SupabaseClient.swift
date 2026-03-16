import Foundation
import Supabase

enum SupabaseConfig {
    // TODO: Replace with your actual Supabase credentials
    // These should match your forget-me-not Supabase project
    static let url = URL(string: "https://yrxtlupqcmxyozwapmor.supabase.co")!
    static let anonKey = "YOUR_ANON_KEY_HERE"
}

let supabase = SupabaseClient(
    supabaseURL: SupabaseConfig.url,
    supabaseKey: SupabaseConfig.anonKey
)
