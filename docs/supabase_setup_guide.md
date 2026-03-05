# Supabase Setup Guide for Kaan

Follow these steps to set up your Supabase project and connect it to the Kaan app.

## 1. Create a Supabase Project
1. Go to [supabase.com](https://supabase.com/) and sign in.
2. Click **"New Project"**.
3. Give it a name (e.g., `podcast-kaan`) and set a strong database password.
4. Wait for the project to provision.

## 2. Get Your API Credentials
1. Once your project is ready, go to **Project Settings** (gear icon) -> **API**.
2. Copy the **Project URL**. This is your `SUPABASE_URL`.
3. Copy the **anon public API key**. This is your `SUPABASE_ANON_KEY`.

## 3. Set Up Database Tables
1. Go to the **SQL Editor** in the left sidebar.
2. Click **"New query"**.
3. Paste the following SQL script to create all necessary tables and functions:

```sql
-- 1. Enable UUID extension
create extension if not exists "uuid-ossp";

-- 2. Profiles Table
create table profiles (
  id uuid references auth.users on delete cascade primary key,
  name text,
  email text,
  phone text,
  avatar_url text,
  bio text,
  languages text[] default '{en}',
  interests text[] default '{}',
  commute_duration_min int default 45,
  preferred_voice text default 'default',
  total_listening_minutes int default 0,
  current_streak int default 0,
  longest_streak int default 0,
  kaan_coins int default 0,
  pahalwan_rank text default 'Chotu',
  street_cred_score int default 0,
  city text,
  pin_code text,
  onboarding_completed boolean default false,
  created_at timestamptz default now()
);

-- 3. Podcasts Table
create table podcasts (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  description text,
  image_url text,
  rss_url text unique,
  author text,
  created_at timestamptz default now()
);

-- 4. Episodes Table
create table episodes (
  id uuid primary key default uuid_generate_v4(),
  podcast_id uuid references podcasts(id) on delete cascade,
  title text not null,
  description text,
  audio_url text not null,
  duration_seconds int,
  category text,
  language text default 'en',
  save_count int default 0,
  published_at timestamptz,
  transcript text,
  ai_summary text,
  created_at timestamptz default now()
);

-- 5. Saved Clips Table
create table saved_clips (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users on delete cascade,
  episode_id uuid references episodes(id) on delete cascade,
  start_seconds int not null,
  end_seconds int not null,
  ai_title text,
  ai_summary text,
  transcript text,
  saved_at timestamptz default now()
);

-- 6. RPC function for incrementing save count
create or replace function increment_save_count(episode_id_param uuid)
returns void as $$
begin
  update episodes
  set save_count = save_count + 1
  where id = episode_id_param;
end;
$$ language plpgsql;
```

4. Click **Run**.

## 4. Enable Authentication
1. Go to **Authentication** -> **Providers**.
2. **Phone**: Enable Phone Auth if you want to use OTP login. You may need to configure a provider like Twilio, or use Supabase's built-in testing numbers.
3. **Email**: Ensure Email Auth is enabled (usually enabled by default).

## 5. Configure Your App
To run the app with your new Supabase project, use the `--dart-define` flags:

```bash
flutter run \
  --dart-define=SUPABASE_URL=your_project_url \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key \
  --dart-define=OPENAI_API_KEY=your_openai_key
```

### VS Code setup
Add this to your `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Kaan (Prod)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define", "SUPABASE_URL=https://your-url.supabase.co",
        "--dart-define", "SUPABASE_ANON_KEY=your-key",
        "--dart-define", "OPENAI_API_KEY=your-openai-key"
      ]
    }
  ]
}
```
