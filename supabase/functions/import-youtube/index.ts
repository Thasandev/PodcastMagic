import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
// @ts-ignore
import ytdl from 'https://esm.sh/ytdl-core@latest'

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders })
    }

    try {
        const { youtubeUrl } = await req.json()
        if (!youtubeUrl) {
            throw new Error("youtubeUrl is required")
        }

        // 1. Get info from YouTube
        console.log(`Getting info for: ${youtubeUrl}`)
        const info = await ytdl.getInfo(youtubeUrl)

        // 2. Select best audio stream
        const audioFormats = ytdl.filterFormats(info.formats, 'audioonly')
        const bestAudio = ytdl.chooseFormat(audioFormats, { quality: 'highestaudio' })

        if (!bestAudio) {
            throw new Error("No audio stream found for this video")
        }

        // 3. Initialize Supabase
        const supabase = createClient(
            Deno.env.get('SUPABASE_URL') ?? '',
            Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
        )

        // 4. Upsert 'YouTube Imports' Podcast
        const podcastData = {
            title: 'YouTube Imports',
            author: 'YouTube',
            description: 'Podcasts imported from YouTube videos',
            image_url: 'https://www.youtube.com/s/desktop/281f33f6/img/favicon_144x144.png',
        }

        const { data: podcast, error: podcastError } = await supabase
            .from('podcasts')
            .upsert(podcastData, { onConflict: 'title' })
            .select()
            .single()

        if (podcastError) throw podcastError

        // 5. Upsert Episode
        const episodeData = {
            podcast_id: podcast.id,
            title: info.videoDetails.title,
            description: info.videoDetails.description || 'Imported from YouTube',
            audio_url: bestAudio.url,
            image_url: info.videoDetails.thumbnails[info.videoDetails.thumbnails.length - 1].url,
            duration_seconds: parseInt(info.videoDetails.lengthSeconds),
            category: 'YouTube',
            published_at: new Date().toISOString(),
        }

        const { data: episode, error: episodeError } = await supabase
            .from('episodes')
            .upsert(episodeData, { onConflict: 'audio_url' })
            .select('*, podcasts(title, image_url)')
            .single()

        if (episodeError) throw episodeError

        return new Response(JSON.stringify({
            success: true,
            episode: episode
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
