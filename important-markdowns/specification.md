
# ✨ FORGET-ME-NOT

### *letters that last*
**v1.0 · march 2026 · with love** 💞

as the founding engineer of this feature: i believe the internet was supposed to connect us, but it made us lonelier instead. forget-me-not is our tiny rebellion against that. 🌊
---

## 💌 why forget-me-not exists

in the old days, people sat down, picked up a pen, and poured themselves onto paper. they waited days, sometimes weeks for a reply from their beloved ones. letters were not just a form of communication, it was a proof that someone somewhere was worth waiting for. relationships were real because they required patience. every letter meant someone chose to spend their time on you.

now people send "wyd" at 2am and get anxious if there's no reply in 5 minutes. love is measured in response times. human connection has become fast food - quick, convenient, forgettable. that's where i imagined this platform where people who want to use it would choose to wait and be waited. respect and get respected. every letter should feel like unwrapping a gift. every word should carry weight.

this is for people who choose real communication over fast living, disposable relationships. for the dreamers, the overthinkers, the ones who still believe that slow things are the most beautiful things. 

you write a letter, and it actually *travels* to the other person based on real geographic distance. istanbul to tokyo? that letter is going to take days. and those days of waiting? that's the whole point. 📜

---

## 🌷 the soul of forget-me-not

### brand identity

- **name:** forget-me-not — because real letters, real feelings, real connections last forever 🖋️
- **feeling:** romantic, dreamy, nostalgic, intimate, celestial
- **colors:** lilac, soft pink-lilac, lavender, deep purple nights 🪻💐
- **dark mode:** deep plum and midnight violet with soft lilac accents — like writing under moonlight
- **who it's for:** 18–35, slow living enthusiasts, journal keepers, deep thinkers, hopeless romantics, dark academia lovers, anyone who misses the art of real conversation 🦢

### why the details matter

i'm adding things like **mbti** and **zodiac signs** to profiles — not because i think personality tests define people, but because people *want* to express themselves. they want to be seen. when you tell someone you're an infp pisces who's currently reading kafka, you're not filling out a form. you're leaving breadcrumbs of your soul for someone to find. 🌼

the **"currently reading"** field, the **"last song i listened to"**, the **"life motto"** — these aren't data points. they're tiny windows into someone's world. and when a stranger across the ocean reads your profile and thinks *"oh, they get it"* — that's where connection begins. ✨

---

## 🐚 bottle mail — founding story

 *strangers passing in the street, by chance two separate glances meet. i am you and what i see is me — echoes, pink floyd*

 *we're just two lost souls swimming in a fish bowl.* - wish you were here - pink floyd

most of what we call love is really just two lonely souls bumping into each other in the dark. two strangers whose glances meet by pure chance. and that's beautiful, actually. because the most meaningful connections in life are the ones we didn't plan. the accidental ones. that's bottle mail. 💌

you write a letter, seal it, and throw it into the ocean. you don't choose who finds it. the universe does (well, our algorithm does, but let's keep the magic alive). someone out there — maybe in brazil, maybe in korea, maybe in the next city - finds your bottle, reads your words, and decides to write back.

the thrill of randomness. the poetry of chance. the idea that somewhere in this massive, chaotic world, your words found exactly the right person.

---

## 📦 memory box

*letters i've written, never meaning to send.* - nights in white satin - the moody blues

not every letter is meant to be sent. some letters are written for people who will never read them. an old friend you lost touch with. someone you loved who doesn't know. a version of yourself you're trying to let go of. your younger self. your future self. memory box is a private space where you can write letters that stay with you. sealed, timestamped, untouched -like a diary, but addressed to someone specific. no one sees them. no one reads them. they're yours. maybe one day you'll unseal them and remember how you felt. maybe you'll finally send one. maybe you won't. the point is that the words exist somewhere, and writing them was enough. ✍🏻

sometimes the act of writing is the healing. you don't need someone to read it. you just need to say it.

**how it works:**
- write a letter → choose "save to memory box" instead of sending
- letters are sealed with a date stamp 📅
- private archive only you can see — organized by recipient name or tag
- optional: set a "time capsule" date — the letter locks and only becomes readable again on that date
- optional: convert a memory box letter into a real letter and send it, whenever you're ready

---

## 🎵 playlist sharing — music connects souls

music is the language people speak when words aren't enough. when someone shares a song with you, they're not just sharing audio — they're sharing a piece of how they feel. a mood. a memory. a moment.

forget-me-not lets users share playlists and songs with their pen pals. because sometimes a letter isn't complete without a soundtrack. 🎧

**how it works:**
- attach a song or playlist link (spotify / apple music) to any letter
- the recipient sees it as a small music card embedded in the letter
- profile feature: **"my soundtrack"** — a public playlist on your profile that represents you
- pen pals can see each other's soundtracks and discover new music together
- ai can suggest: *"you both listen to radiohead — you might connect over music"* 🌠

because some people fall in love through words. others fall in love through the same song playing at the same time, on different sides of the world. 💞

---

## 📖 the forget-me-not blog — love stories that never grow old

*now, we are one in everlasting peace.* exit music - radiohead

forget-me-not isn't just a platform. it's a world. and every world needs its mythology. the forget-me-not blog tells the stories of lovers across history, mythology, and literature — the ones who wrote letters, who waited, who loved across impossible distances.

orpheus descending into the underworld for eurydice. abelard and heloise writing across monastery walls. kafka pouring his soul into letters to milena that he knew would change nothing. heathcliff and catherine - a love so wild it outlived death itself. brontë wrote a love story that was really about obsession, longing, and the impossibility of separating two souls that grew up intertwined. the moors, the wind, the ghost at the window - it's all about the letters we write to people who are already gone. these stories will be posted in a blog.

**what the blog includes:**
- weekly stories of famous lovers and their letters ✉️
- mythology deep dives — tragic love stories from greek, norse, persian, japanese mythology
- literary love — the romances behind the greatest novels ever written
- "letter of the week" — a featured historical letter with context and analysis
- writing prompts inspired by these stories
- user-submitted love stories (anonymous, moderated)

this isn't a marketing blog. this is the cultural backbone of forget-me-not. it's what makes us more than an app — it makes us a community that *celebrates* the art of loving slowly. 🌹

---

## 🎀 tech stack

| layer | technology |
|-------|-----------|
| frontend | Next.js 14 (App Router) + Tailwind CSS |
| backend / db | Supabase (PostgreSQL + Auth + Realtime + Storage) |
| ai | Anthropic Claude API |
| maps | Mapbox GL JS / Leaflet |
| payments | Stripe |
| hosting | Vercel |
| mobile (phase 2) | React Native / Expo |

---

## 🗺️ site map

**40+ screens total**

### auth flow 🔐
1. **landing page** — hero, features, cta
2. **register** — email + google oauth
3. **login** — email + google oauth
4. **password reset** — email verification

### onboarding flow 🌸
1. **avatar selection** — illustrated avatar library (no real photos — mystery is beautiful)
2. **basic info** — display name, age, country, city, language(s)
3. **mbti** — 16 types
4. **zodiac** — sun sign + optional rising/moon
5. **interest tags** — curated multi-select
6. **bio** — free text, 300 chars max
7. **profile depth** — currently reading 📖, last song 🎵, life motto
8. **privacy** — location visibility toggle

### dashboard 🏠
1. **inbox** — incoming + in-transit letters with countdown ⏳
2. **outbox** — sent letters with delivery status
3. **conversations** — active pen pals with streak indicators 🔥

### letter system 📝
1. **compose** — text editor + stamp selector + song attachment + ai ice-breaker panel
2. **read** — full letter view with sender info + embedded music card
3. **journey map** — watch your letter travel across the world 🗺️
4. **archive** — timeline view of past letters
5. **daily question** — conversation prompt card

### memory box 📦
1. **write to memory box** — compose a private letter, choose recipient name/tag
2. **my memory box** — sealed letters archive, organized by person or date
3. **time capsule view** — locked letters with countdown to unlock date
4. **unseal & send** — option to convert a memory box letter into a real one

### discovery & matching 🔍
1. **explore** — filters (age, language, interests) + ai compatibility scores
2. **user cards** — avatar, bio, shared interests, compatibility %
3. **match detail** — full preview + "write a letter" cta

### bottle mail 🐚
1. **send a bottle** — choose filters + write letter
2. **find a bottle** — open a random bottle + reply
3. **auto-rematch** — no reply? your letter finds someone new

### profile 🦢
1. **my profile (view)** — everything about you + stamp showcase + my soundtrack 🎵
2. **my profile (edit)** — update anything
3. **other's profile** — view + send letter button + their soundtrack
4. **stamp collection** — owned vs locked stamps grid
5. **xp & levels** — progress bar, streak stats

### blog 📖
1. **blog home** — latest stories, featured letter of the week
2. **story page** — individual mythology/love story with illustrations
3. **writing prompts** — inspired by the stories, shareable with pen pals
4. **community stories** — user-submitted anonymous love stories

### store 🛍️
1. **stamp store** — premium + xp-unlockable stamps
2. **theme packs** — papers, envelopes, premium features

### settings ⚙️
1. **account** — email, password, linked accounts
2. **notifications** — push, email, in-app toggles
3. **privacy** — location & profile visibility
4. **block & report** — manage blocked users
5. **delete account** — confirmation + data export

### moderation 🛡️
1. **report flow** — short letter, "add me on insta", harassment
2. **admin panel** — review reports, manage users

### support 💬
1. **faq / help center**
2. **contact us**
3. **community guidelines**

---

## 📜 core mechanics

### letter delivery — patience is the point

> ⏳ *forget-me-not — foo fighters*

letters travel based on **real geographic distance**. this is non-negotiable. it's the entire philosophy.

**formula:** `delivery_hours = distance_km / 100`

| route | distance | delivery time |
|-------|----------|---------------|
| istanbul → ankara | ~450 km | ~4.5 hours |
| istanbul → berlin | ~2,200 km | ~22 hours |
| istanbul → tokyo | ~8,500 km | ~3.5 days |
| same city | < 30 km | 30 min (minimum) |

minimum: **30 minutes** (even next door — good things take time)
maximum: **7 days** (for the furthest points on earth)

> 🎶 *and now, we are one in everlasting peace*

**letter states:**

| state | meaning |
|-------|---------|
| `DRAFT` | still writing ✏️ |
| `IN_TRANSIT` | on its way — countdown visible to both 🕊️ |
| `DELIVERED` | arrived, waiting to be opened 💌 |
| `READ` | opened and read 👀 |
| `EXPIRED` | unopened for 30 days — returned to sender 📬 |

### keeping it real — activity enforcement 🚫👻

ghost users kill platforms like these. not on my watch.

- **14 days no reply** → gentle reminder notification to the recipient
- **21 days no reply** → profile visibility reduced in explore
- **still nothing?** → sender gets the option to **auto-rematch**: same letter, new person
- users can **decline** a letter (no penalty) — this immediately triggers rematch for sender
- **reportable offenses:** letters under 50 characters, social media solicitation ("add me on insta" → instant report option)

the message is clear: if you're here, *be here*. 💐

### matching system 🔗

**explore / search:**
- language filter (mandatory — must share at least one)
- age range
- interest tags
- country / region (optional)
- sorted by ai compatibility score

**bottle mail:**
- filtered by language + interests
- profiles visible (not anonymous)
- no reply in 14 days → auto-rematch to new person

### avatars 🎭

no real photos. ever. mystery is part of the magic. ✨

illustrated avatars in categories: animals, celestial objects, abstract art, seasonal specials. some unlocked via xp. premium avatars in the store.

---

## 🌟 gamification

### xp system

| action | xp |
|--------|-----|
| send a letter (200+ chars) | +10 |
| send a letter (500+ chars) | +25 |
| receive a reply | +15 |
| complete daily question | +5 |
| 7-day streak | +50 bonus |
| 30-day streak | +200 bonus |
| send a bottle letter | +10 |
| first letter to new pen pal | +20 |
| save a letter to memory box | +5 |
| share a song with a letter | +5 |

### levels 🌱→🌌

| level | xp needed | unlock |
|-------|-----------|--------|
| 1 — seedling 🌱 | 0 | basic features |
| 2 — sprout 🌿 | 100 | stamp: first light |
| 3 — bloom 🌸 | 300 | avatar pack: celestial |
| 4 — stargazer ⭐ | 600 | stamp: moonrise |
| 5 — constellation 🌙 | 1,000 | bottle mail x3/day |
| 6 — aurora 🌌 | 1,500 | profile badge |
| 7 — nebula 💜 | 2,500 | stamp: deep space |
| 8 — eclipse 🌑 | 4,000 | custom status text |
| 9 — supernova 💫 | 6,000 | exclusive avatar |
| 10 — cosmos ✨ | 10,000 | founder badge + all stamps |

### streaks 🔥

a streak lives between two people. send/receive a letter within 7 days to keep it alive. milestones at 7, 30, 100, and 365 days unlock special stamps.

### stamp collection 🎟️

every letter carries one stamp. stamps are tiny pieces of art.

| type | how to get |
|------|-----------|
| free | everyone gets ~10 basics |
| xp | unlocked at level milestones |
| seasonal | limited-time holiday/event drops |
| premium | purchased in store |

locked stamps show as silhouettes on your profile. collecting them all is the endgame. 🏆

---

## 🤖 ai features

ai is here to help humans connect better — never to replace the human part. powered by **anthropic claude api**.

### ai compatibility score 💞
- shared interests (weighted by specificity)
- mbti compatibility matrix
- language overlap
- writing style analysis (kicks in after 5+ letters)
- activity level similarity
- music taste overlap (from shared songs and playlists) 🎵

### ai ice-breaker 🧊
optional panel when writing your first letter to someone:
- *"you both love murakami — ask about their favorite book"* 📖
- *"fellow infp from japan — ask about growing up there"*
- *"shared interest: astronomy — ask about the last time they stargazed"* 🌠
- *"you both listen to radiohead — ask what their favorite album is"* 🎧

the ai **never** writes the letter. it just nudges you. you can dismiss it anytime.

### daily question 💭
a new thoughtful question every day on the dashboard. categories: philosophy, memories, dreams, creativity, relationships, the world.

*"if you could send one letter to your 16-year-old self, what would you say?"*

### ai translation 🌍
toggle translation below the original text. original always shown first. labeled *"ai translation — original above."* because hearing someone's real words matters, even if you need a little help understanding.

### ai mood palette 🎨
after writing, ai suggests a background color that matches the emotional tone. sender can accept or change. recipient sees the mood when reading — like feeling the weather of someone's heart.

---

## 💰 monetization

### free tier (generous)
- unlimited letters
- 10 basic stamps
- explore with filters
- 1 bottle mail per day
- 3 ai ice-breaker suggestions per letter
- basic avatar set
- memory box (up to 20 saved letters)
- 1 playlist slot on profile

### store 🛍️

| item | price |
|------|-------|
| premium stamp packs | $0.99 – $2.99 |
| exclusive avatars | $0.99 |
| paper/envelope themes | $1.99 |
| extra bottle mails | $0.49 |

### forget-me-not plus ✨ — $4.99/month
- unlimited bottle mails
- ai translation on all letters
- ai mood palette
- ad-free
- monthly exclusive stamp
- priority in explore
- advanced filters (mbti, zodiac)
- unlimited memory box letters
- unlimited playlist slots

---

## 🎯 goals & retention strategy

### user goals

| metric | 3 months | 6 months | 12 months |
|--------|----------|----------|-----------|
| registered users | 5,000 | 25,000 | 100,000 |
| daily active users | 500 | 3,000 | 15,000 |
| avg letters per user/week | 3 | 4 | 5 |
| premium conversion | 2% | 5% | 8% |
| 30-day retention | 30% | 40% | 50% |

### how we keep people coming back 🌻

**the waiting game:** the delivery system itself creates natural engagement loops. you send a letter → you check back to see if it arrived → you wait for a reply → the countdown creates anticipation. no push needed — curiosity does the work.

**streaks & fomo:** losing a 30-day streak hurts. people will come back just to keep it alive. (snapchat proved this works.)

**daily question:** a new question every day gives people a reason to open the app even when they have no letters. it's a tiny ritual. ☕

**stamp drops:** seasonal and limited-time stamps create urgency. "spring collection available for 2 weeks only" — collectors will stay active.

**bottle mail randomness:** the thrill of "who will find my bottle today?" is addictive in the best way.

**memory box as journal:** even when you have no pen pals online, you can write to your memory box. forget-me-not becomes part of your daily emotional routine — not just a social app, but a personal one too. 📦

**music discovery:** people will check their pen pal's new songs, share discoveries, build shared playlists over time. music is the glue that makes people stay. 🎵

**the blog:** weekly mythology stories and love letters from history give people content to read, share, and discuss with pen pals. it turns forget-me-not into a cultural space, not just a messaging tool. 📖

**activity enforcement:** ghost users don't just hurt themselves — they hurt the people writing to them. our rematch system means no letter ever goes to waste. if someone stops engaging, the platform self-heals by redirecting letters to active users.

**community feeling:** i want people to feel like they belong to something. forget-me-not isn't just an app — it's a movement for people who believe the world moves too fast. 🌍💞

---

## 🗄️ database schema

supabase / postgresql.

### `users`

| column | type | notes |
|--------|------|-------|
| id | UUID (PK) | supabase auth id |
| display_name | VARCHAR(50) | |
| email | VARCHAR | unique |
| avatar_id | INT (FK) | → avatars |
| age | INT | |
| country | VARCHAR | iso code |
| city | VARCHAR | |
| latitude | DECIMAL | for distance calc |
| longitude | DECIMAL | for distance calc |
| location_visible | BOOLEAN | default: true |
| languages | TEXT[] | language codes |
| mbti | VARCHAR(4) | e.g., INFP |
| zodiac | VARCHAR(20) | sun sign |
| bio | VARCHAR(300) | |
| current_book | VARCHAR(100) | |
| last_song | VARCHAR(100) | |
| life_motto | VARCHAR(200) | |
| soundtrack_url | VARCHAR(500) | spotify/apple music playlist link |
| xp | INT | default: 0 |
| level | INT | default: 1 |
| is_premium | BOOLEAN | |
| created_at | TIMESTAMP | |
| last_active_at | TIMESTAMP | |

### `letters`

| column | type | notes |
|--------|------|-------|
| id | UUID (PK) | |
| sender_id | UUID (FK) | → users |
| recipient_id | UUID (FK) | → users (nullable for memory box) |
| content | TEXT | letter body |
| stamp_id | INT (FK) | → stamps |
| mood_color | VARCHAR(7) | hex from ai mood |
| song_url | VARCHAR(500) | attached song link |
| status | ENUM | DRAFT, IN_TRANSIT, DELIVERED, READ, EXPIRED, MEMORY_BOX |
| is_bottle | BOOLEAN | bottle mail flag |
| is_memory_box | BOOLEAN | private letter flag |
| memory_box_recipient | VARCHAR(100) | name/tag for unsent letters |
| time_capsule_date | TIMESTAMP | nullable — unlock date for time capsules |
| distance_km | DECIMAL | calc at send time |
| delivery_hours | DECIMAL | distance_km / 100 |
| sent_at | TIMESTAMP | |
| delivers_at | TIMESTAMP | sent_at + delivery_hours |
| read_at | TIMESTAMP | nullable |

### `blog_posts`

| column | type | notes |
|--------|------|-------|
| id | UUID (PK) | |
| title | VARCHAR(200) | |
| slug | VARCHAR(200) | url-friendly |
| content | TEXT | markdown body |
| category | ENUM | mythology, historical_letters, literary_love, writing_prompts, community |
| cover_image_url | VARCHAR(500) | |
| published_at | TIMESTAMP | |
| is_featured | BOOLEAN | letter of the week |

### other tables

- **interests** — id, name, category
- **user_interests** — user_id, interest_id
- **stamps** — id, name, image_url, category, xp_required, price
- **user_stamps** — user_id, stamp_id, acquired_at
- **avatars** — id, image_url, category, xp_required, price
- **streaks** — user_a_id, user_b_id, count, last_letter_at
- **reports** — id, reporter_id, reported_user_id, letter_id, reason, status, created_at
- **blocks** — blocker_id, blocked_id, created_at
- **notifications** — id, user_id, type, content, read, created_at
- **daily_questions** — id, question_text, category, date
- **transactions** — id, user_id, item_type, item_id, amount, stripe_id, created_at

---

## 🔧 development layers

| layer | name | deliverables | est. time |
|-------|------|-------------|-----------|
| 0 | foundation 🏗️ | repo, design system, db schema, auth, components | 1–2 weeks |
| 1 | auth & onboarding 🔐 | landing, register, login, reset, 8-step onboarding | 1–2 weeks |
| 2 | profile & shell 🦢 | profile crud, dashboard skeleton, settings, notifications | 1 week |
| 3 | letter core 💌 | compose, send, deliver, read, inbox/outbox, distance calc, song attachment | 2–3 weeks |
| 4 | memory box 📦 | write, seal, archive, time capsule, unseal & send | 1 week |
| 5 | discovery 🔍 | explore, filters, user cards, match detail, ai compatibility | 1–2 weeks |
| 6 | bottle mail 🐚 | send/find bottles, matching, auto-rematch | 1 week |
| 7 | gamification 🌟 | xp, levels, streaks, stamps, store, payments | 2 weeks |
| 8 | ai features 🤖 | ice-breaker, translation, mood palette, daily question | 1–2 weeks |
| 9 | blog 📖 | cms, story pages, writing prompts, community stories | 1 week |
| 10 | moderation 🛡️ | reports, content filter, admin panel, enforcement | 1 week |
| 11 | map & visuals 🗺️ | letter journey, archive timeline, profile cards | 1 week |
| 12 | polish & launch 🚀 | perf, seo, analytics, help pages, beta, launch | 1–2 weeks |

**total: ~14–20 weeks** (solo, full-time)

---

## 📱 phase 2: mobile

after web mvp + user feedback:
- react native / expo for ios
- push notifications (essential for letter alerts)
- haptic feedback on letter opening
- ios widget — letter countdown on home screen ⏳

---

## 🌸 next steps

1. finalize this prd
2. layer 0: repo, design system, database
3. wireframes for each screen
4. layer 1: auth + onboarding (first prototype)
5. layer by layer, testing each before moving on
6. beta launch with close friends
7. iterate based on feedback
8. public launch 🚀

---

<p align="center">

✨ **FORGET-ME-NOT** ✨

*built with love, patience, and a lot of tea at midnight.* 🫖🌙

</p>
