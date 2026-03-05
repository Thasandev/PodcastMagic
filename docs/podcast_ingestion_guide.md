# Podcast Ingestion Guide

To connect Kaan to actual audio, you need a way to pull data from RSS feeds into your Supabase database.

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
