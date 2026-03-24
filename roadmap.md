# Roadmap

## Phase 1: Foundation
- [x] project setup with xcodegen and supabase swift sdk
- [x] database schema with all tables, rls, triggers, seed data
- [x] data models for user, letter, stamp, avatar, interest, friendship
- [x] supabase client with config.plist
- [x] theme system with baby blue parchment palette

## Phase 2: Services
- [x] auth service with signup, signin, signout, session restore
- [x] letter service with inbox, sent, drafts, realtime, bottle mail
- [x] user service with profile crud, pen pal search, friendships
- [x] stamp service with collection, unlocks, xp system
- [x] distance calculator with haversine formula
- [x] level system with xp progression

## Phase 3: Views
- [x] splash screen and auth gate
- [x] login and register views
- [x] multi-step onboarding (name, country, languages, interests, personality, avatar)
- [x] home view with globe visualization and envelope cards
- [x] friends view with conversation history
- [x] explore view with world map, filters, pen pal profiles
- [x] compose view with stamp picker and 50 word minimum
- [x] bottle mail feature (send to random stranger)
- [x] drafts view
- [x] profile view with avatar builder, stamp collection, settings
- [x] all reusable components (avatar, stamp, globe, envelope, wax seal, flow layout)

## Phase 4: Polish
- [ ] run schema.sql on supabase dashboard
- [ ] end to end testing of auth flow
- [ ] letter opening animation
- [ ] push notifications for letter delivery
- [ ] app icon and launch screen design
- [ ] real pixel art stamps
- [ ] real layered avatar assets
- [ ] dark mode support
- [ ] haptic feedback
- [ ] sound effects

## Phase 5: Launch
- [ ] app store listing and screenshots
- [ ] privacy policy and terms of service
- [ ] testflight beta
- [ ] app store submission
