# Roadmap

## Phase 1: Foundation
- [x] project setup
- [x] data models (Letter, AppUser, Avatar, Stamp, Interest, Friendship)
- [x] basic navigation (5-tab: Letters, Explore, Compose, Stamps, Profile)
- [x] theme system (baby blue + typewriter aesthetic)
- [x] distance utility (haversine formula)
- [x] levels/xp system

## Phase 2: Asset Generation (PixelLab)
- [x] app icon (pixel art daylight logo)
- [x] stamps: flowers (8), animals (6), symbols (8), seasonal (6), extra (16)
- [x] UI icons: tab bar, navigation, actions, status
- [x] letter visuals: envelopes, mailbox, typewriter, pen/ink, extras
- [x] room furniture: 18 stardew valley style pieces
- [x] avatar presets: 6 hair x 4 skin = 24 combos
- [x] paper doll template + drawing guide
- [ ] avatars: paper doll parts hand-drawn (damla)
- [ ] onboarding visuals

## Phase 3: Backend + Core Features
- [x] supabase schema (profiles, letters, stamps, user_stamps, interests, friendships)
- [x] row level security policies
- [x] auth service (signup, signin, signout, session restore)
- [x] letter service (send, fetch inbox/sent, mark read, realtime)
- [x] user service (profile CRUD, onboarding, pen pal search)
- [x] stamp service (collection, unlock, xp-based unlocks)
- [x] config.plist for secure key storage
- [x] auth gate (login/register/onboarding flow)
- [x] login + register views
- [x] onboarding flow (name, country, languages, interests, avatar, mbti/zodiac)
- [x] letters inbox view (real data, pull to refresh, realtime)
- [x] letter card view (avatar top-left, stamp top-right)
- [x] letter detail view (parchment paper, mark as read)
- [x] compose view (recipient picker, stamp picker, send)
- [x] explore view (pen pal discovery by interests/languages)
- [x] stamp collection view (grid, locked/unlocked, categories)
- [x] profile view (real data, avatar, stats, interests)
- [x] settings view (edit profile, sign out)
- [ ] run supabase schema on production database
- [ ] test full auth flow end to end
- [ ] test letter sending and delivery
- [ ] push notifications ("a letter has arrived")

## Phase 4: Social & Discovery
- [ ] bottle mail (random stranger letter)
- [ ] memory box (private journal letters)
- [ ] time capsule letters (scheduled delivery)
- [ ] block/report users

## Phase 5: Monetization (Slowly Plus model)
- [ ] premium subscription (yearly)
- [ ] coins system (earn via ads, buy avatar items)
- [ ] premium stamps (purchasable)
- [ ] premium avatar accessories
- [ ] ad integration for free coin earning

## Phase 6: Polish & Extras
- [ ] music/song attachment to letters
- [ ] animations (letter flying, stamp placing)
- [ ] dark mode
- [ ] room system (furniture placement, persistence)
- [ ] app store screenshots + metadata
