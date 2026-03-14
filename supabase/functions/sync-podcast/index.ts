import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { parseFeed } from "https://deno.land/x/rss/mod.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { rssUrl, category, limit = 20 } = await req.json()
    
    if (!rssUrl) {
      return new Response(JSON.stringify({ error: "rssUrl is required" }), { 
        status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } 
      })
    }

    // 1. Fetch and parse RSS
    console.log(`Fetching RSS feed: ${rssUrl}`)
    const response = await fetch(rssUrl)
    const xml = await response.text()
    const feed = await parseFeed(xml)

    // 2. Initialize Supabase
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 3. Upsert Podcast
    const podcastData = {
      title: feed.title.value,
      description: feed.description,
      image_url: feed.image?.url,
      rss_url: rssUrl,
      author: feed.author?.name
    }

    const { data: podcast, error: podcastError } = await supabase
      .from('podcasts')
      .upsert(podcastData, { onConflict: 'rss_url' })
      .select()
      .single()

    if (podcastError) {
       console.error("Error upserting podcast:", podcastError)
       throw podcastError
    }

    // 4. Upsert Episodes
    let count = 0
    const syncedEpisodes = []
    for (const item of feed.entries) {
      if (count >= limit) break; // Only sync latest 'limit' episodes

      const audioUrl = item.enclosures?.[0]?.url
      if (!audioUrl) continue

      // Try to parse duration (very basic, typically iTunes duration is format HH:MM:SS or just seconds)
      let durationSeconds = 0
      // In a real app we would parse item['itunes:duration'] if available from the parsed feed
      
      const publishedAt = item.published ? new Date(item.published).toISOString() : new Date().toISOString()

      const { error: episodeError } = await supabase.from('episodes').upsert({
        podcast_id: podcast.id,
        title: item.title?.value || 'Untitled',
        description: item.description?.value || '',
        audio_url: audioUrl,
        duration_seconds: durationSeconds, 
        category: category || 'General',
        published_at: publishedAt
      }, { onConflict: 'audio_url' }) // assuming audio url is unique
      
      if (episodeError) {
          console.error("Error inserting episode:", episodeError)
      } else {
          count++;
          // Fetch the inserted episode to return it (or construct it from item)
          syncedEpisodes.push({
            id: crypto.randomUUID(), // placeholder if we don't fetch, but better to fetch
            podcast_id: podcast.id,
            title: item.title?.value || 'Untitled',
            audio_url: audioUrl,
            category: category || 'General',
            published_at: publishedAt,
            podcasts: {
              title: podcast.title,
              image_url: podcast.image_url
            }
          })
      }
    }

    // Better way: Fetch actual episodes from DB after sync to ensure consistency
    const { data: dbEpisodes } = await supabase
      .from('episodes')
      .select('*, podcasts(title, image_url)')
      .eq('podcast_id', podcast.id)
      .order('published_at', { ascending: false })
      .limit(limit)

    return new Response(JSON.stringify({ 
      success: true, 
      podcast: podcast,
      episodes: dbEpisodes || syncedEpisodes,
      episodesAdded: count
    }), { 
      headers: { ...corsHeaders, "Content-Type": "application/json" } 
    })

  } catch (err) {
    console.error(err)
    return new Response(JSON.stringify({ error: err.message }), { 
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } 
    })
  }
})
