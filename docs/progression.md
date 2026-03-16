# 🌙 everlong — devlog

---

## day 01 — 05 march 2026

- reviewed PRD and prototype (prototype.html — vibecoded mock, no db)
- decided on stack: next.js 14 + supabase + tailwind + typescript
- created supabase project, ran full db schema
  - tables: users, avatars, interests, user_interests, stamps, user_stamps,
    letters, streaks, blog_posts, notifications, blocks, reports, daily_questions
  - auth trigger: auto-creates user row on signup
  - rls policies set up from day one
- initialized next.js project (app router, typescript, tailwind)
- installed @supabase/supabase-js @supabase/ssr
- configured .env.local with supabase url + anon key
- fixed nested folder issue (everlong/everlong → everlong)


- set up supabase client in lib/supabase.ts
- wrote typescript types in types/index.ts — User, Letter, Stamp, BlogPost, Notification
- configured design system in tailwind.config.ts
- globals.css — @theme color palette, atmospheric noise, radial glow
- app/layout.tsx — loaded cormorant garamond, outfit, caveat fonts
- app/page.tsx — first screen working, dark background + lilac typography
