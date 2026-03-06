import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { Innertube } from 'npm:youtubei.js'
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Max-Age': '86400',
}

serve(async (req) => {
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders, status: 200 })
    }

    try {
        const { youtubeUrl } = await req.json()
        if (!youtubeUrl) {
            throw new Error("youtubeUrl is required")
        }

        // 1. Initialize Innertube
        console.log(`Initializing Innertube for: ${youtubeUrl}`)
        const yt = await Innertube.create()

        // 2. Extract Video ID from URL
        const videoId = youtubeUrl.includes('v=')
            ? youtubeUrl.split('v=')[1].split('&')[0]
            : youtubeUrl.split('/').pop()?.split('?')[0]

        if (!videoId) throw new Error("Could not extract video ID from URL")

        // 3. Get info from YouTube
        console.log(`Getting info for video ID: ${videoId}`)
        const info = await yt.getInfo(videoId)

        // 4. Get basic metadata
        const details = info.basic_info
        const title = details.title || 'Unknown Title'
        const description = details.short_description || details.description || 'Imported from YouTube'
        const durationSeconds = details.duration || 0
        const author = details.author || 'YouTube'
        const imageUrl = details.thumbnail?.[0]?.url || ''

        // 5. Get streaming data (audio only)
        const format = info.chooseFormat({ type: 'audio', quality: 'best' })
        if (!format) {
            throw new Error("No audio stream found for this video")
        }
        const audioUrl = format.decipher(yt.session.player)

        // 6. Initialize Supabase
        const supabase = createClient(
            Deno.env.get('SUPABASE_URL') ?? '',
            Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
        )

        // 7. Upsert 'YouTube Imports' Podcast
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

        // 8. Upsert Episode
        const episodeData = {
            podcast_id: podcast.id,
            title: title,
            description: description,
            audio_url: audioUrl,
            image_url: imageUrl,
            duration_seconds: durationSeconds,
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
