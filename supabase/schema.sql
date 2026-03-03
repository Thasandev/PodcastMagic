-- Kaan App - Supabase Database Schema
-- Run this in the Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- USERS & PROFILES
-- ============================================

CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL DEFAULT 'Kaan User',
  email TEXT,
  phone TEXT,
  avatar_url TEXT,
  bio TEXT,
  languages TEXT[] DEFAULT ARRAY['en'],
  interests TEXT[] DEFAULT ARRAY[]::TEXT[],
  commute_duration_min INTEGER DEFAULT 45,
  preferred_voice TEXT DEFAULT 'default',
  total_listening_minutes INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  kaan_coins INTEGER DEFAULT 0,
  pahalwan_rank TEXT DEFAULT 'Chotu',
  street_cred_score INTEGER DEFAULT 0,
  city TEXT,
  pin_code TEXT,
  onboarding_completed BOOLEAN DEFAULT FALSE,
  last_listened_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, name, email)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', 'Kaan User'),
    NEW.email
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- CONTENT (PODCASTS & EPISODES)
-- ============================================

CREATE TABLE IF NOT EXISTS podcasts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  rss_url TEXT,
  language TEXT DEFAULT 'en',
  category TEXT NOT NULL,
  author TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS episodes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  podcast_id UUID REFERENCES podcasts(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  audio_url TEXT NOT NULL,
  duration_seconds INTEGER NOT NULL,
  language TEXT DEFAULT 'en',
  category TEXT NOT NULL,
  ai_summary TEXT,
  ai_summary_hinglish TEXT,
  transcript TEXT,
  chapters JSONB DEFAULT '[]'::JSONB,
  guest_info JSONB,
  save_count INTEGER DEFAULT 0,
  play_count INTEGER DEFAULT 0,
  published_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_episodes_category ON episodes(category);
CREATE INDEX idx_episodes_language ON episodes(language);
CREATE INDEX idx_episodes_published_at ON episodes(published_at DESC);

-- ============================================
-- LIBRARY (SAVES & CLIPS)
-- ============================================

CREATE TABLE IF NOT EXISTS saved_clips (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  episode_id UUID NOT NULL REFERENCES episodes(id) ON DELETE CASCADE,
  start_seconds INTEGER NOT NULL,
  end_seconds INTEGER NOT NULL,
  ai_title TEXT,
  ai_summary TEXT,
  transcript TEXT,
  is_offline BOOLEAN DEFAULT FALSE,
  saved_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_saved_clips_user ON saved_clips(user_id, saved_at DESC);

-- ============================================
-- PLAYLISTS
-- ============================================

CREATE TABLE IF NOT EXISTS playlists (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  created_by UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  is_collaborative BOOLEAN DEFAULT FALSE,
  total_duration_seconds INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS playlist_members (
  playlist_id UUID REFERENCES playlists(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  role TEXT DEFAULT 'member', -- 'owner', 'member'
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (playlist_id, user_id)
);

CREATE TABLE IF NOT EXISTS playlist_episodes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  playlist_id UUID REFERENCES playlists(id) ON DELETE CASCADE,
  episode_id UUID REFERENCES episodes(id) ON DELETE CASCADE,
  added_by UUID REFERENCES profiles(id),
  position INTEGER NOT NULL,
  added_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- REFLECTIONS (CHAI PE CHARCHA)
-- ============================================

CREATE TABLE IF NOT EXISTS reflections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  episode_id UUID REFERENCES episodes(id),
  audio_url TEXT,
  transcript TEXT NOT NULL,
  duration_seconds INTEGER DEFAULT 0,
  city TEXT,
  is_public BOOLEAN DEFAULT TRUE,
  upvotes INTEGER DEFAULT 0,
  reaction_count INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_reflections_city ON reflections(city, created_at DESC);
CREATE INDEX idx_reflections_user ON reflections(user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS reflection_reactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reflection_id UUID NOT NULL REFERENCES reflections(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- 'upvote', 'voice', 'emoji'
  emoji TEXT, -- if type is 'emoji'
  audio_url TEXT, -- if type is 'voice'
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(reflection_id, user_id, type)
);

-- ============================================
-- KAAN COINS
-- ============================================

CREATE TABLE IF NOT EXISTS coin_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- 'earned', 'spent'
  amount INTEGER NOT NULL,
  reason TEXT NOT NULL,
  reference_id TEXT, -- optional reference to related entity
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_coin_transactions_user ON coin_transactions(user_id, created_at DESC);

-- ============================================
-- STREAKS
-- ============================================

CREATE TABLE IF NOT EXISTS streak_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  listening_minutes INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, date)
);

CREATE TABLE IF NOT EXISTS streak_insurance (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  insured_by UUID REFERENCES profiles(id), -- friend who insured
  date DATE NOT NULL,
  used BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- LEADERBOARDS (DANGAL)
-- ============================================

CREATE TABLE IF NOT EXISTS leaderboard_weekly (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  week_start DATE NOT NULL,
  listening_minutes INTEGER DEFAULT 0,
  city TEXT,
  office_domain TEXT, -- email domain for office grouping
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, week_start)
);

CREATE INDEX idx_leaderboard_city ON leaderboard_weekly(city, listening_minutes DESC);
CREATE INDEX idx_leaderboard_office ON leaderboard_weekly(office_domain, listening_minutes DESC);

-- ============================================
-- BADGES
-- ============================================

CREATE TABLE IF NOT EXISTS badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  icon TEXT NOT NULL,
  criteria JSONB NOT NULL, -- e.g., {"type": "streak", "value": 30}
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_badges (
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  badge_id UUID REFERENCES badges(id) ON DELETE CASCADE,
  unlocked_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, badge_id)
);

-- ============================================
-- LISTENING HISTORY
-- ============================================

CREATE TABLE IF NOT EXISTS listening_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  episode_id UUID NOT NULL REFERENCES episodes(id) ON DELETE CASCADE,
  progress_seconds INTEGER DEFAULT 0,
  completed BOOLEAN DEFAULT FALSE,
  listened_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_listening_history_user ON listening_history(user_id, listened_at DESC);

-- ============================================
-- FRIENDS & SOCIAL
-- ============================================

CREATE TABLE IF NOT EXISTS friendships (
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  friend_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'pending', -- 'pending', 'accepted'
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, friend_id)
);

CREATE TABLE IF NOT EXISTS referrals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  referrer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  referee_id UUID REFERENCES profiles(id),
  referral_code TEXT NOT NULL UNIQUE,
  status TEXT DEFAULT 'pending', -- 'pending', 'completed'
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- REMIXES (COPY CAT)
-- ============================================

CREATE TABLE IF NOT EXISTS remixes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  original_clip_id UUID REFERENCES saved_clips(id),
  original_episode_id UUID REFERENCES episodes(id),
  audio_url TEXT NOT NULL,
  title TEXT,
  description TEXT,
  play_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_clips ENABLE ROW LEVEL SECURITY;
ALTER TABLE playlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE reflections ENABLE ROW LEVEL SECURITY;
ALTER TABLE coin_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE streak_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE listening_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE remixes ENABLE ROW LEVEL SECURITY;

-- Profiles: users can read all, update own
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE TO authenticated USING (auth.uid() = id);

-- Saved clips: users can CRUD own
CREATE POLICY "Users can view own clips"
  ON saved_clips FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Users can create clips"
  ON saved_clips FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own clips"
  ON saved_clips FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Reflections: public are viewable, users can CRUD own
CREATE POLICY "Public reflections are viewable"
  ON reflections FOR SELECT TO authenticated USING (is_public = true OR auth.uid() = user_id);
CREATE POLICY "Users can create reflections"
  ON reflections FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own reflections"
  ON reflections FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Episodes: viewable by all authenticated users
ALTER TABLE episodes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Episodes are viewable by everyone"
  ON episodes FOR SELECT TO authenticated USING (true);

-- Podcasts: viewable by all
ALTER TABLE podcasts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Podcasts are viewable by everyone"
  ON podcasts FOR SELECT TO authenticated USING (true);

-- Coin transactions: users can view own
CREATE POLICY "Users can view own transactions"
  ON coin_transactions FOR SELECT TO authenticated USING (auth.uid() = user_id);

-- Streak records: users can view own
CREATE POLICY "Users can view own streaks"
  ON streak_records FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own streaks"
  ON streak_records FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

-- Leaderboards: viewable by all
ALTER TABLE leaderboard_weekly ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leaderboards are viewable by everyone"
  ON leaderboard_weekly FOR SELECT TO authenticated USING (true);

-- Listening history: users own
CREATE POLICY "Users can view own history"
  ON listening_history FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own history"
  ON listening_history FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

-- ============================================
-- REALTIME SUBSCRIPTIONS
-- ============================================

ALTER PUBLICATION supabase_realtime ADD TABLE reflections;
ALTER PUBLICATION supabase_realtime ADD TABLE leaderboard_weekly;
ALTER PUBLICATION supabase_realtime ADD TABLE coin_transactions;

-- ============================================
-- SEED DATA: Sample badges
-- ============================================

INSERT INTO badges (name, description, icon, criteria) VALUES
  ('Early Bird', 'Listen before 7 AM for 7 days', '🌅', '{"type": "early_listening", "days": 7}'),
  ('Knowledge Seeker', 'Save 50 clips', '📚', '{"type": "saves", "count": 50}'),
  ('Social Butterfly', 'Share 10 reflections', '🦋', '{"type": "reflections", "count": 10}'),
  ('Streak Master', '30-day listening streak', '🔥', '{"type": "streak", "days": 30}'),
  ('Polyglot', 'Listen in 3 different languages', '🌏', '{"type": "languages", "count": 3}'),
  ('Night Owl', 'Listen after midnight for 7 days', '🦉', '{"type": "night_listening", "days": 7}'),
  ('Remix King', 'Create 10 remixes', '🎤', '{"type": "remixes", "count": 10}'),
  ('Pados Ka Hero', 'Top listener in your pin code', '🏆', '{"type": "local_rank", "rank": 1}'),
  ('City Champion', 'Reach Top 10 in city leaderboard', '👑', '{"type": "city_rank", "rank": 10}'),
  ('Chai Pe Charcha Star', '50 upvotes on a single reflection', '⭐', '{"type": "reflection_upvotes", "count": 50}')
ON CONFLICT (name) DO NOTHING;
