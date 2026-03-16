# daylight iOS — Build Plan

## What we have now (Foundation)

A working Xcode project with Supabase dependency, connecting to the same backend as the forget-me-not web app.

```
daylight/
├── App/              — Entry point + ContentView (splash)
├── Models/           — All 7 data models matching Supabase schema
├── Services/         — Supabase client connection
├── Theme/            — Color palette, fonts, spacing
├── Utils/            — Distance calc, XP levels, country coords
├── Fonts/            — (empty) Drop .ttf/.otf files here
└── Assets.xcassets/
    ├── AppIcon        — (empty) 1024x1024 app icon
    ├── Avatars/       — (empty) Drop avatar PNGs here
    ├── Stamps/        — (empty) Drop stamp PNGs here
    └── Illustrations/
        ├── EmptyStates/   — Empty inbox, empty bottle, etc.
        ├── Loading/       — Bird carrying letter, wax seal, etc.
        ├── Onboarding/    — One per step
        └── LetterPaper/   — Floral, celestial, vintage frames
```

## How to add art assets

### Avatars (24-40 illustrations)
1. Draw in Habbo Hotel x Studio Ghibli style
2. Export as PNG, transparent background, ~200x200px
3. Name: `avatar_01.png`, `avatar_02.png`, etc.
4. Create folder: `Assets.xcassets/Avatars/avatar_01.imageset/`
5. Put PNG inside + add Contents.json:
```json
{
  "images": [{ "filename": "avatar_01.png", "idiom": "universal" }],
  "info": { "author": "xcode", "version": 1 }
}
```
6. Use in code: `Image("Avatars/avatar_01")`

### Stamps (30-50 illustrations)
Same process but in `Assets.xcassets/Stamps/`
- 64-80px, perforated edges aesthetic
- Name: `stamp_nature_01.png`, `stamp_animal_01.png`, etc.
- Use in code: `Image("Stamps/stamp_nature_01")`

### Illustrations
Same process in `Assets.xcassets/Illustrations/{subfolder}/`
- Use in code: `Image("Illustrations/EmptyStates/empty_inbox")`

### Fonts
1. Download .ttf or .otf files for: Cormorant Garamond, Outfit, Caveat
2. Drop into `daylight/Fonts/`
3. Add to Info.plist under "Fonts provided by application"
4. Theme.swift already references them by name

## Build Order (brick by brick)

### Step 1: Splash → Login → Register
Build the auth flow. User opens app → sees splash → login screen → can register.

### Step 2: Onboarding
5-step flow: avatar pick, about you, mbti, interests, soul crumbs.

### Step 3: Main Tab Bar + Inbox
Tab navigation (inbox, explore, compose, bottle, profile). Inbox shows letters.

### Step 4: Compose
Write a letter, pick recipient, select stamp, attach song.

### Step 5: Letter Detail
Open and read a letter, see sender info, reply.

### Step 6: Explore
Browse users, filter by language/interests, write to someone new.

### Step 7: Bottle Mail
Throw a bottle, find a bottle.

### Step 8: Memory Box
Unsent letters, time capsules.

### Step 9: Profile
Stats, XP bar, stamp collection, soul crumbs, settings.

### Step 10: Blog
Stories about famous letters in history.

### Step 11: Polish
Haptic feedback, animations, push notifications, widget.
