-- Drop existing daylight tables to start clean
DROP TABLE IF EXISTS user_stamps CASCADE;
DROP TABLE IF EXISTS friendships CASCADE;
DROP TABLE IF EXISTS letters CASCADE;
DROP TABLE IF EXISTS stamps CASCADE;
DROP TABLE IF EXISTS interests CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS handle_new_user();
DROP FUNCTION IF EXISTS deliver_letters();
DROP FUNCTION IF EXISTS update_updated_at();

-- Profiles (extends auth.users)
CREATE TABLE profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    display_name TEXT,
    avatar_config JSONB DEFAULT '{}'::jsonb,
    age INT,
    country TEXT,
    city TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    languages TEXT[] DEFAULT '{}',
    interests TEXT[] DEFAULT '{}',
    mbti TEXT,
    zodiac TEXT,
    bio TEXT DEFAULT '',
    xp INT DEFAULT 0,
    level INT DEFAULT 1,
    is_premium BOOLEAN DEFAULT FALSE,
    onboarding_complete BOOLEAN DEFAULT FALSE,
    last_seen TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Interests
CREATE TABLE interests (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Stamps
CREATE TABLE stamps (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    image_name TEXT NOT NULL,
    category TEXT NOT NULL,
    xp_required INT DEFAULT 0,
    is_premium BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Letters
CREATE TABLE letters (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    sender_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    recipient_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    content TEXT NOT NULL,
    stamp_id UUID REFERENCES stamps(id),
    status TEXT NOT NULL DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'IN_TRANSIT', 'DELIVERED', 'READ')),
    is_bottle BOOLEAN DEFAULT FALSE,
    distance_km DOUBLE PRECISION DEFAULT 0,
    delivery_hours DOUBLE PRECISION DEFAULT 1,
    sent_at TIMESTAMPTZ,
    delivers_at TIMESTAMPTZ,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User stamps
CREATE TABLE user_stamps (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    stamp_id UUID REFERENCES stamps(id) ON DELETE CASCADE NOT NULL,
    unlocked_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, stamp_id)
);

-- Friendships
CREATE TABLE friendships (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    friend_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'blocked')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, friend_id)
);

-- Indexes
CREATE INDEX idx_letters_sender ON letters(sender_id);
CREATE INDEX idx_letters_recipient ON letters(recipient_id);
CREATE INDEX idx_letters_status ON letters(status);
CREATE INDEX idx_letters_delivers_at ON letters(delivers_at);
CREATE INDEX idx_friendships_user ON friendships(user_id);
CREATE INDEX idx_friendships_friend ON friendships(friend_id);
CREATE INDEX idx_user_stamps_user ON user_stamps(user_id);
CREATE INDEX idx_profiles_country ON profiles(country);

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (id) VALUES (NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Deliver letters
CREATE OR REPLACE FUNCTION deliver_letters()
RETURNS void AS $$
BEGIN
    UPDATE letters SET status = 'DELIVERED'
    WHERE status = 'IN_TRANSIT' AND delivers_at <= NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE letters ENABLE ROW LEVEL SECURITY;
ALTER TABLE stamps ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_stamps ENABLE ROW LEVEL SECURITY;
ALTER TABLE interests ENABLE ROW LEVEL SECURITY;
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;

CREATE POLICY "profiles_select" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles_update" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "profiles_insert" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "letters_select" ON letters FOR SELECT
    USING (auth.uid() = sender_id OR auth.uid() = recipient_id);
CREATE POLICY "letters_insert" ON letters FOR INSERT
    WITH CHECK (auth.uid() = sender_id);
CREATE POLICY "letters_update" ON letters FOR UPDATE
    USING (auth.uid() = sender_id OR auth.uid() = recipient_id);
CREATE POLICY "letters_delete" ON letters FOR DELETE
    USING (auth.uid() = sender_id AND status = 'DRAFT');

CREATE POLICY "stamps_select" ON stamps FOR SELECT USING (true);

CREATE POLICY "user_stamps_select" ON user_stamps FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "user_stamps_insert" ON user_stamps FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "interests_select" ON interests FOR SELECT USING (true);

CREATE POLICY "friendships_select" ON friendships FOR SELECT
    USING (auth.uid() = user_id OR auth.uid() = friend_id);
CREATE POLICY "friendships_insert" ON friendships FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "friendships_update" ON friendships FOR UPDATE
    USING (auth.uid() = user_id OR auth.uid() = friend_id);

-- Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE letters;

-- Seed interests
INSERT INTO interests (name, category) VALUES
    ('Travel', 'Lifestyle'), ('Photography', 'Creative'), ('Reading', 'Culture'),
    ('Writing', 'Creative'), ('Music', 'Culture'), ('Movies', 'Culture'),
    ('Cooking', 'Lifestyle'), ('Gaming', 'Entertainment'), ('Art', 'Creative'),
    ('Science', 'Academic'), ('Philosophy', 'Academic'), ('History', 'Academic'),
    ('Technology', 'Academic'), ('Languages', 'Culture'), ('Nature', 'Lifestyle'),
    ('Yoga', 'Lifestyle'), ('Fitness', 'Lifestyle'), ('Fashion', 'Lifestyle'),
    ('Poetry', 'Creative'), ('Astronomy', 'Academic'), ('Psychology', 'Academic'),
    ('Anime', 'Entertainment');

-- Seed stamps
INSERT INTO stamps (name, image_name, category, xp_required, is_premium) VALUES
    ('First Letter', 'stamp_first_letter', 'Welcome', 0, false),
    ('Hello World', 'stamp_hello_world', 'Welcome', 0, false),
    ('Sunrise', 'stamp_sunrise', 'Welcome', 0, false),
    ('Paper Plane', 'stamp_paper_plane', 'Welcome', 0, false),
    ('Quill Pen', 'stamp_quill_pen', 'Welcome', 0, false),
    ('Mountain Peak', 'stamp_mountain', 'Nature', 100, false),
    ('Ocean Wave', 'stamp_ocean', 'Nature', 150, false),
    ('Cherry Blossom', 'stamp_cherry_blossom', 'Nature', 200, false),
    ('Northern Lights', 'stamp_northern_lights', 'Nature', 300, false),
    ('Desert Sunset', 'stamp_desert_sunset', 'Nature', 400, false),
    ('Rainforest', 'stamp_rainforest', 'Nature', 500, false),
    ('Tokyo Tower', 'stamp_tokyo', 'Cities', 200, false),
    ('Eiffel Tower', 'stamp_paris', 'Cities', 250, false),
    ('Big Ben', 'stamp_london', 'Cities', 300, false),
    ('Statue of Liberty', 'stamp_new_york', 'Cities', 350, false),
    ('Colosseum', 'stamp_rome', 'Cities', 400, false),
    ('Taj Mahal', 'stamp_taj_mahal', 'Cities', 450, false),
    ('Great Wall', 'stamp_great_wall', 'Cities', 500, false),
    ('Sydney Opera', 'stamp_sydney', 'Cities', 600, false),
    ('Spring Bloom', 'stamp_spring', 'Seasons', 100, false),
    ('Summer Sun', 'stamp_summer', 'Seasons', 150, false),
    ('Autumn Leaf', 'stamp_autumn', 'Seasons', 200, false),
    ('Winter Snow', 'stamp_winter', 'Seasons', 300, false),
    ('Aries', 'stamp_aries', 'Zodiac', 200, false),
    ('Taurus', 'stamp_taurus', 'Zodiac', 200, false),
    ('Gemini', 'stamp_gemini', 'Zodiac', 200, false),
    ('Cancer', 'stamp_cancer', 'Zodiac', 200, false),
    ('Leo', 'stamp_leo', 'Zodiac', 200, false),
    ('Virgo', 'stamp_virgo', 'Zodiac', 200, false),
    ('Libra', 'stamp_libra', 'Zodiac', 200, false),
    ('Scorpio', 'stamp_scorpio', 'Zodiac', 200, false),
    ('Sagittarius', 'stamp_sagittarius', 'Zodiac', 200, false),
    ('Capricorn', 'stamp_capricorn', 'Zodiac', 200, false),
    ('Aquarius', 'stamp_aquarius', 'Zodiac', 200, false),
    ('Pisces', 'stamp_pisces', 'Zodiac', 200, false),
    ('Golden Envelope', 'stamp_golden_envelope', 'Premium', 0, true),
    ('Crystal Ball', 'stamp_crystal_ball', 'Premium', 0, true),
    ('Phoenix Feather', 'stamp_phoenix', 'Premium', 0, true);
