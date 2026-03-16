# daylight

Native iOS app for the daylight slow letter platform. 
Built with Swift & S
wiftUI.

Letters travel by real geographic distance — Istanbul to Tokyo takes ~3.5 days. The waiting is the point.

## Tech

- Swift / SwiftUI (iOS 17+)
- Supabase Swift SDK (auth, database, realtime)
- Same backend as the web app

## Setup

1. Open `daylight.xcodeproj` in Xcode
2. Wait for Swift packages to resolve
3. Update `Services/SupabaseClient.swift` with your Supabase anon key
4. Drop custom fonts (.ttf) into `Fonts/` folder
5. Build & run

## Project Structure

```
daylight/
├── App/           — Entry point, main views
├── Models/        — Supabase data models
├── Services/      — Supabase client
├── Theme/         — Colors, fonts, spacing
├── Utils/         — Distance, levels, countries
├── Fonts/         — Custom typefaces (Cormorant, Outfit, Caveat)
└── Assets.xcassets/
    ├── Avatars/       — Character illustrations
    ├── Stamps/        — Postage stamp illustrations
    └── Illustrations/ — Empty states, loading, onboarding, letter paper
```
