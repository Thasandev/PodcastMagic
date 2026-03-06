import { serve } from "https://deno.land/std@0.168.0/http/server.ts"


const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders })
    }

    try {
        const { query, provider = 'itunes' } = await req.json()

        if (!query) {
            return new Response(JSON.stringify({ error: "query is required" }), {
                status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" }
            })
        }

        let results = []

        if (provider === 'itunes') {
            // iTunes Search API (Default, Free, No Auth)
            const encodedQuery = encodeURIComponent(query)
            const url = `https://itunes.apple.com/search?media=podcast&term=${encodedQuery}&limit=20`
            const response = await fetch(url)
            const data = await response.json()

            results = data.results.map((item: any) => ({
                title: item.collectionName,
                author: item.artistName,
                imageUrl: item.artworkUrl600 || item.artworkUrl100,
                rssUrl: item.feedUrl,
                provider: 'itunes'
            })).filter((item: any) => item.rssUrl); // Only return podcasts that have an RSS feed

        } else if (provider === 'podcastindex') {
            // PodcastIndex API
            // Requires adding secrets: supabase secrets set PI_API_KEY=your_key PI_API_SECRET=your_secret
            const apiKey = Deno.env.get('PI_API_KEY')
            const apiSecret = Deno.env.get('PI_API_SECRET')

            if (!apiKey || !apiSecret) {
                throw new Error("PodcastIndex API keys not configured in Supabase Secrets")
            }

            const apiHeaderTime = Math.floor(Date.now() / 1000).toString();
            const hashStr = apiKey + apiSecret + apiHeaderTime;

            // Generate SHA-1 hash using Web Crypto API
            const encoder = new TextEncoder();
            const dataToHash = encoder.encode(hashStr);
            const hashBuffer = await crypto.subtle.digest('SHA-1', dataToHash);
            const hashArray = Array.from(new Uint8Array(hashBuffer));
            const hashHex = hashArray.map((b) => b.toString(16).padStart(2, '0')).join('');

            const url = `https://api.podcastindex.org/api/1.0/search/byterm?q=${encodeURIComponent(query)}&max=20`
            const response = await fetch(url, {
                headers: {
                    "User-Agent": "KaanPodcastApp/1.0",
                    "X-Auth-Date": apiHeaderTime,
                    "X-Auth-Key": apiKey,
                    "Authorization": hashHex
                }
            })
            const data = await response.json()
            results = (data.feeds || []).map((item: any) => ({
                title: item.title,
                author: item.author,
                imageUrl: item.image,
                rssUrl: item.url,
                provider: 'podcastindex'
            }))

        } else if (provider === 'listennotes') {
            // ListenNotes API
            // Requires adding config: supabase secrets set LISTEN_NOTES_API_KEY=your_key
            const apiKey = Deno.env.get('LISTEN_NOTES_API_KEY')
            if (!apiKey) {
                throw new Error("ListenNotes API key not configured in Supabase Secrets")
            }

            const url = `https://listen-api.listennotes.com/api/v2/search?q=${encodeURIComponent(query)}&type=podcast`
            const response = await fetch(url, {
                headers: { "X-ListenAPI-Key": apiKey }
            })
            const data = await response.json()
            results = (data.results || []).map((item: any) => ({
                title: item.title_original,
                author: item.publisher_original,
                imageUrl: item.image,
                rssUrl: item.rss,
                provider: 'listennotes'
            }))
        } else {
            throw new Error(`Unknown provider: ${provider}`)
        }

        return new Response(JSON.stringify({ success: true, results }), {
            headers: { ...corsHeaders, "Content-Type": "application/json" }
        })

    } catch (err) {
        console.error(err)
        return new Response(JSON.stringify({ error: err.message }), {
            status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" }
        })
    }
})
