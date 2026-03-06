# Podcast Ingestion Guide

To connect Kaan (or any podcast app) to actual audio, you need to understand how the podcast ecosystem works, where to get the data, and how to stream the audio.

## The Podcast Ecosystem & End-to-End Flow

Podcasts are fundamentally powered by **RSS Feeds** (XML files). When a creator publishes a podcast, they upload the actual `.mp3` audio files to a **Podcast Host** (like Anchor, Libsyn, or Megaphone). The host generates an RSS feed containing the metadata and links to those audio files.

Here is the end-to-end flow of how audio gets to your app:

1. **Discovery/Search (The APIs):** Your app needs a way to find podcasts. You query a public podcast directory database (like PodcastIndex or Apple Podcasts API). The API returns the podcast's global **RSS Feed URL**.
2. **Parsing the Feed:** Your backend (or the app directly) fetches the XML from that RSS Feed URL and parses it. Inside the XML, every episode has an `<enclosure url="...mp3" />` tag.
3. **Audio Streaming:** You don't host the audio files yourself. You extract that `.mp3` URL and feed it directly to your app's audio player (e.g., `just_audio` in Flutter, or HTML5 `<audio>` on Web). The audio streams directly from the creator's host to the user's device.
4. **Storage (Optional but recommended):** To make your app fast, your backend should periodically fetch these RSS feeds, extract the audio URLs, and store them in your own database (like Supabase). Your app then talks solely to your database.

## Where to get Podcast Data (Servers/APIs)

You can connect to these public directories to search for podcasts and get their RSS URLs:

1. **PodcastIndex API (Recommended):** The most open, comprehensive, and developer-friendly podcast database. It contains millions of podcasts.
   - *Use Case:* Searching for podcasts, getting trending lists, and fetching feed URLs.
   - *Cost:* Free tier available.
2. **Apple Podcasts API (iTunes Search API):** The industry standard. Most podcasts explicitly submit to Apple, making their database very complete.
   - *Use Case:* Searching by term `https://itunes.apple.com/search?media=podcast&term=technology`. Returns RSS feed URLs.
   - *Cost:* Free, but has rate limits.
3. **ListenNotes API:** A premium, highly polished commercial API for podcast search.
   - *Use Case:* Advanced semantic search, comprehensive metadata.
   - *Cost:* Has a free tier for testing, paid for production.
4. **Your own Supabase DB:** Ultimately, you use the APIs above to find RSS feeds, and then you rely on your Supabase backend to store the parsed episodes for your app to display.
## 1. Database Setup
Run this SQL in your Supabase SQL Editor to create the necessary tables if they don't exist:

```sql
-- Podcasts Table
CREATE TABLE podcasts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  rss_url TEXT UNIQUE,
  author TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Episodes Table
CREATE TABLE episodes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  podcast_id UUID REFERENCES podcasts(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  audio_url TEXT NOT NULL,
  duration_seconds INTEGER,
  category TEXT,
  language TEXT,
  save_count INTEGER DEFAULT 0,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  transcript TEXT,
  ai_summary TEXT
);
```

## 2. Ingestion via Supabase Edge Functions
The most efficient way to sync podcasts is using a background function.

### Example Edge Function (Deno/TypeScript)
Create a function at `supabase/functions/sync-podcast/index.ts`:

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { parseFeed } from "https://deno.land/x/rss/mod.ts"

serve(async (req) => {
  const { rssUrl, category } = await req.json()
  
  // 1. Fetch and parse RSS
  const response = await fetch(rssUrl)
  const xml = await response.text()
  const feed = await parseFeed(xml)

  // 2. Initialize Supabase
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
  )

  // 3. Upsert Podcast
  const { data: podcast } = await supabase
    .from('podcasts')
    .upsert({
      title: feed.title.value,
      description: feed.description,
      image_url: feed.image?.url,
      rss_url: rssUrl
    })
    .select()
    .single()

  // 4. Upsert Episodes
  for (const item of feed.entries) {
    const audioUrl = item.enclosures?.[0]?.url
    if (!audioUrl) continue

    await supabase.from('episodes').upsert({
      podcast_id: podcast.id,
      title: item.title.value,
      description: item.description?.value,
      audio_url: audioUrl,
      duration_seconds: 0, // Should be parsed from itunes:duration
      category: category,
      published_at: item.published
    })
  }

  return new Response(JSON.stringify({ success: true }), { headers: { "Content-Type": "application/json" } })
})
```

## 3. Frontend Integration
In your Flutter app, you can trigger this function or simply query the `episodes` table using `SupabaseService().getFeed()`.

### Example Riverpod Provider
```dart
final episodeFeedProvider = FutureProvider.family<List<Episode>, String?>((ref, category) async {
  return await SupabaseService().getFeed(category: category);
});
```
