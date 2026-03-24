-- ============================================================================
-- daylight — letter-writing pen pal app
-- Supabase SQL schema  (shared project: yrxtlupqcmxyozwapmor)
-- ============================================================================

-- ============================================================================
-- 0. Extensions
-- ============================================================================
create extension if not exists "pgcrypto";

-- ============================================================================
-- 1. TABLES
-- ============================================================================

-- ---------- profiles ----------
create table if not exists public.profiles (
    id                  uuid primary key references auth.users (id) on delete cascade,
    display_name        text,
    avatar_config       jsonb default '{}'::jsonb,
    age                 int check (age >= 13 and age <= 120),
    country             text,
    city                text,
    latitude            double precision,
    longitude           double precision,
    location_visible    boolean not null default true,
    languages           text[] default '{}',
    mbti                text check (mbti is null or mbti in (
                            'INTJ','INTP','ENTJ','ENTP',
                            'INFJ','INFP','ENFJ','ENFP',
                            'ISTJ','ISFJ','ESTJ','ESFJ',
                            'ISTP','ISFP','ESTP','ESFP')),
    zodiac              text check (zodiac is null or zodiac in (
                            'aries','taurus','gemini','cancer',
                            'leo','virgo','libra','scorpio',
                            'sagittarius','capricorn','aquarius','pisces')),
    bio                 text check (char_length(bio) <= 500),
    current_book        text,
    last_song           text,
    life_motto          text check (char_length(life_motto) <= 200),
    xp                  int not null default 0,
    level               int not null default 1,
    is_premium          boolean not null default false,
    onboarding_complete boolean not null default false,
    created_at          timestamptz not null default now(),
    last_active_at      timestamptz not null default now()
);

create index idx_profiles_country      on public.profiles (country);
create index idx_profiles_last_active   on public.profiles (last_active_at desc);
create index idx_profiles_onboarding    on public.profiles (onboarding_complete);

-- ---------- stamps ----------
create table if not exists public.stamps (
    id          serial primary key,
    name        text not null,
    image_name  text not null,
    category    text not null check (category in ('flowers','animals','symbols','seasonal','extra')),
    xp_required int not null default 0,
    is_premium  boolean not null default false,
    created_at  timestamptz not null default now()
);

create index idx_stamps_category on public.stamps (category);

-- ---------- letters ----------
create table if not exists public.letters (
    id              uuid primary key default gen_random_uuid(),
    sender_id       uuid not null references public.profiles (id) on delete cascade,
    recipient_id    uuid not null references public.profiles (id) on delete cascade,
    content         text not null check (char_length(content) > 0),
    stamp_id        int references public.stamps (id) on delete set null,
    song_url        text,
    status          text not null default 'IN_TRANSIT'
                        check (status in ('DRAFT','IN_TRANSIT','DELIVERED','READ')),
    is_bottle       boolean not null default false,
    distance_km     double precision,
    delivery_hours  double precision,
    sent_at         timestamptz,
    delivers_at     timestamptz,
    read_at         timestamptz,
    created_at      timestamptz not null default now(),

    constraint letters_sender_neq_recipient check (sender_id <> recipient_id)
);

create index idx_letters_sender     on public.letters (sender_id, created_at desc);
create index idx_letters_recipient  on public.letters (recipient_id, created_at desc);
create index idx_letters_status     on public.letters (status);
create index idx_letters_delivers   on public.letters (delivers_at) where status = 'IN_TRANSIT';

-- ---------- user_stamps ----------
create table if not exists public.user_stamps (
    id          uuid primary key default gen_random_uuid(),
    user_id     uuid not null references public.profiles (id) on delete cascade,
    stamp_id    int not null references public.stamps (id) on delete cascade,
    unlocked_at timestamptz not null default now(),

    constraint uq_user_stamp unique (user_id, stamp_id)
);

create index idx_user_stamps_user on public.user_stamps (user_id);

-- ---------- interests ----------
create table if not exists public.interests (
    id       serial primary key,
    name     text not null unique,
    category text not null
);

create index idx_interests_category on public.interests (category);

-- ---------- user_interests ----------
create table if not exists public.user_interests (
    user_id     uuid not null references public.profiles (id) on delete cascade,
    interest_id int not null references public.interests (id) on delete cascade,
    primary key (user_id, interest_id)
);

create index idx_user_interests_interest on public.user_interests (interest_id);

-- ---------- friendships ----------
create table if not exists public.friendships (
    id          uuid primary key default gen_random_uuid(),
    user_id     uuid not null references public.profiles (id) on delete cascade,
    friend_id   uuid not null references public.profiles (id) on delete cascade,
    status      text not null default 'pending'
                    check (status in ('pending','accepted','blocked')),
    created_at  timestamptz not null default now(),

    constraint uq_friendship unique (user_id, friend_id),
    constraint friendships_no_self check (user_id <> friend_id)
);

create index idx_friendships_friend on public.friendships (friend_id);
create index idx_friendships_status on public.friendships (status);


-- ============================================================================
-- 2. ROW LEVEL SECURITY
-- ============================================================================

-- ---------- profiles ----------
alter table public.profiles enable row level security;

create policy "profiles_select_all"
    on public.profiles for select
    using (true);

create policy "profiles_insert_own"
    on public.profiles for insert
    with check (auth.uid() = id);

create policy "profiles_update_own"
    on public.profiles for update
    using (auth.uid() = id)
    with check (auth.uid() = id);

-- ---------- letters ----------
alter table public.letters enable row level security;

create policy "letters_select_own"
    on public.letters for select
    using (auth.uid() = sender_id or auth.uid() = recipient_id);

create policy "letters_insert_own"
    on public.letters for insert
    with check (auth.uid() = sender_id);

create policy "letters_update_own_sender"
    on public.letters for update
    using (auth.uid() = sender_id and status = 'DRAFT');

-- recipients can mark letters as READ
create policy "letters_update_recipient_read"
    on public.letters for update
    using (auth.uid() = recipient_id and status = 'DELIVERED')
    with check (status = 'READ');

-- ---------- stamps ----------
alter table public.stamps enable row level security;

create policy "stamps_select_all"
    on public.stamps for select
    using (true);

-- ---------- user_stamps ----------
alter table public.user_stamps enable row level security;

create policy "user_stamps_select_own"
    on public.user_stamps for select
    using (auth.uid() = user_id);

create policy "user_stamps_insert_own"
    on public.user_stamps for insert
    with check (auth.uid() = user_id);

-- ---------- interests ----------
alter table public.interests enable row level security;

create policy "interests_select_all"
    on public.interests for select
    using (true);

-- ---------- user_interests ----------
alter table public.user_interests enable row level security;

create policy "user_interests_select_own"
    on public.user_interests for select
    using (auth.uid() = user_id);

create policy "user_interests_insert_own"
    on public.user_interests for insert
    with check (auth.uid() = user_id);

create policy "user_interests_delete_own"
    on public.user_interests for delete
    using (auth.uid() = user_id);

-- ---------- friendships ----------
alter table public.friendships enable row level security;

create policy "friendships_select_own"
    on public.friendships for select
    using (auth.uid() = user_id or auth.uid() = friend_id);

create policy "friendships_insert_own"
    on public.friendships for insert
    with check (auth.uid() = user_id);

create policy "friendships_update_own"
    on public.friendships for update
    using (auth.uid() = user_id or auth.uid() = friend_id);

create policy "friendships_delete_own"
    on public.friendships for delete
    using (auth.uid() = user_id);


-- ============================================================================
-- 3. FUNCTIONS & TRIGGERS
-- ============================================================================

-- Auto-create profile on new auth.users signup
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
    insert into public.profiles (id, display_name, created_at, last_active_at)
    values (
        new.id,
        coalesce(new.raw_user_meta_data ->> 'display_name', 'Traveler'),
        now(),
        now()
    );
    return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
    after insert on auth.users
    for each row
    execute function public.handle_new_user();


-- Calculate delivery hours from distance: distance_km / 100, min 0.5h, max 72h
create or replace function public.calculate_delivery_hours(distance double precision)
returns double precision
language plpgsql
immutable
as $$
declare
    hours double precision;
begin
    if distance is null or distance <= 0 then
        return 0.5;
    end if;

    hours := distance / 100.0;

    if hours < 0.5 then
        return 0.5;
    elsif hours > 72.0 then
        return 72.0;
    end if;

    return round(hours::numeric, 2)::double precision;
end;
$$;


-- Deliver letters whose delivery time has passed
create or replace function public.deliver_letters()
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
    delivered_count int;
begin
    update public.letters
    set status = 'DELIVERED'
    where status = 'IN_TRANSIT'
      and delivers_at <= now();

    get diagnostics delivered_count = row_count;
    return delivered_count;
end;
$$;


-- Auto-set delivery fields when a letter is sent (status changes to IN_TRANSIT)
create or replace function public.handle_letter_send()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
    sender_lat   double precision;
    sender_lon   double precision;
    recip_lat    double precision;
    recip_lon    double precision;
    dist         double precision;
    hours        double precision;
begin
    -- only calculate on insert with IN_TRANSIT status
    if new.status = 'IN_TRANSIT' and new.delivers_at is null then
        select latitude, longitude into sender_lat, sender_lon
        from public.profiles where id = new.sender_id;

        select latitude, longitude into recip_lat, recip_lon
        from public.profiles where id = new.recipient_id;

        -- calculate distance using haversine approximation
        if sender_lat is not null and sender_lon is not null
           and recip_lat is not null and recip_lon is not null then
            dist := 6371 * acos(
                least(1.0, greatest(-1.0,
                    cos(radians(sender_lat)) * cos(radians(recip_lat)) *
                    cos(radians(recip_lon) - radians(sender_lon)) +
                    sin(radians(sender_lat)) * sin(radians(recip_lat))
                ))
            );
        else
            -- default to a random distance if location unknown
            dist := 500 + random() * 4500;
        end if;

        hours := public.calculate_delivery_hours(dist);

        new.distance_km     := round(dist::numeric, 1)::double precision;
        new.delivery_hours  := hours;
        new.sent_at         := coalesce(new.sent_at, now());
        new.delivers_at     := coalesce(new.sent_at, now()) + (hours || ' hours')::interval;
    end if;

    return new;
end;
$$;

drop trigger if exists on_letter_send on public.letters;
create trigger on_letter_send
    before insert on public.letters
    for each row
    execute function public.handle_letter_send();


-- ============================================================================
-- 4. REALTIME
-- ============================================================================

alter publication supabase_realtime add table public.letters;


-- ============================================================================
-- 5. SEED DATA — STAMPS
-- ============================================================================

insert into public.stamps (name, image_name, category, xp_required, is_premium) values
    -- flowers
    ('Sunflower',       'stamp_sunflower',       'flowers', 0,    false),
    ('Rose',            'stamp_rose',            'flowers', 0,    false),
    ('Tulip',           'stamp_tulip',           'flowers', 50,   false),
    ('Daisy',           'stamp_daisy',           'flowers', 100,  false),
    ('Lily',            'stamp_lily',            'flowers', 200,  false),
    ('Lavender',        'stamp_lavender',        'flowers', 300,  false),
    ('Cherry Blossom',  'stamp_cherry_blossom',  'flowers', 500,  false),
    ('Lotus',           'stamp_lotus',           'flowers', 800,  true),

    -- animals
    ('Butterfly',       'stamp_butterfly',       'animals', 0,    false),
    ('Bird',            'stamp_bird',            'animals', 0,    false),
    ('Cat',             'stamp_cat',             'animals', 100,  false),
    ('Rabbit',          'stamp_rabbit',          'animals', 200,  false),
    ('Fox',             'stamp_fox',             'animals', 400,  false),
    ('Deer',            'stamp_deer',            'animals', 600,  true),

    -- symbols
    ('Star',            'stamp_star',            'symbols', 0,    false),
    ('Moon',            'stamp_moon',            'symbols', 0,    false),
    ('Heart',           'stamp_heart',           'symbols', 50,   false),
    ('Key',             'stamp_key',             'symbols', 150,  false),
    ('Compass',         'stamp_compass',         'symbols', 250,  false),
    ('Hourglass',       'stamp_hourglass',       'symbols', 350,  false),
    ('Feather',         'stamp_feather',         'symbols', 500,  false),
    ('Lantern',         'stamp_lantern',         'symbols', 700,  true),

    -- seasonal
    ('Snowflake',       'stamp_snowflake',       'seasonal', 100,  false),
    ('Autumn Leaf',     'stamp_autumn_leaf',     'seasonal', 100,  false),
    ('Spring Rain',     'stamp_spring_rain',     'seasonal', 100,  false),
    ('Summer Sun',      'stamp_summer_sun',      'seasonal', 100,  false),
    ('Halloween',       'stamp_halloween',       'seasonal', 300,  true),
    ('Christmas',       'stamp_christmas',       'seasonal', 300,  true),

    -- extra
    ('Coffee',          'stamp_coffee',          'extra', 0,    false),
    ('Cake',            'stamp_cake',            'extra', 50,   false),
    ('Crystal Ball',    'stamp_crystal_ball',    'extra', 150,  false),
    ('Polaroid',        'stamp_polaroid',        'extra', 250,  false),
    ('Vinyl',           'stamp_vinyl',           'extra', 350,  false),
    ('Typewriter',      'stamp_typewriter',      'extra', 500,  false),
    ('Book',            'stamp_book',            'extra', 200,  false),
    ('Music Note',      'stamp_music_note',      'extra', 300,  false),
    ('Telescope',       'stamp_telescope',       'extra', 600,  true),
    ('Globe',           'stamp_globe',           'extra', 800,  true)
on conflict do nothing;


-- ============================================================================
-- 6. SEED DATA — INTERESTS
-- ============================================================================

insert into public.interests (name, category) values
    -- literature
    ('poetry',       'literature'),
    ('novels',       'literature'),
    ('philosophy',   'literature'),
    ('journalism',   'literature'),

    -- arts
    ('music',        'arts'),
    ('film',         'arts'),
    ('photography',  'arts'),
    ('painting',     'arts'),
    ('theater',      'arts'),

    -- science
    ('astronomy',    'science'),
    ('psychology',   'science'),
    ('biology',      'science'),
    ('technology',   'science'),

    -- lifestyle
    ('travel',       'lifestyle'),
    ('cooking',      'lifestyle'),
    ('gardening',    'lifestyle'),
    ('yoga',         'lifestyle'),
    ('fashion',      'lifestyle'),

    -- culture
    ('history',      'culture'),
    ('languages',    'culture'),
    ('mythology',    'culture'),
    ('architecture', 'culture')
on conflict (name) do nothing;
