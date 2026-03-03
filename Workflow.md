# Kaan (Commute Audio) – Complete Product Requirements Document

## 1. Overview

**Kaan** is a hyper-personalized audio platform designed for India's daily commuters. It transforms wasted commute time (30–120 minutes daily) into productive, enjoyable learning and entertainment. The app curates short audio "snacks" (news, book summaries, comedy, educational clips, podcasts) into a seamless playlist that matches the user's commute duration, interests, and mood.

Kaan combines all features of the popular app **Snipd** (AI-powered podcast highlights, transcripts, knowledge management) with **eight viral hooks** specifically engineered for the Indian market. The result is a habit-forming, socially engaging, and monetizable platform that will become the default daily ritual for millions of Indian commuters.

The application is built with **Flutter** to target **iOS, Android, and Web (PWA)** from a single codebase, ensuring a consistent experience across platforms while maximizing reach.

---

## 2. Core Features

### 2.1 All Snipd Features (Localized for India)

| Snipd Feature | Kaan Implementation |
|----------------|---------------------|
| **One-Tap Headphone Snips** | "Suno" save – triple-tap headphones or voice command "Suno" to save moments; works with cheap neckbands common in India. |
| **AI-Generated Snippet Boundaries** | AI automatically determines optimal start/end points, with improved sync accuracy based on user feedback. |
| **Auto-Generated Titles & Summaries** | Summaries in Hinglish + 8 regional languages (Tamil, Telugu, Bengali, Marathi, Gujarati, Punjabi, Malayalam, Kannada). Auto-detects language mix. |
| **Personalized Summary Emails** | Daily/weekly email recaps with key takeaways; also available as WhatsApp messages. |
| **PKM Integrations** | Notion, Readwise, Obsidian, plus local notes apps (Google Keep, Apple Notes) and offline-first sync. |
| **Real-Time Animated Transcripts** | Follow along with synchronized, animated transcripts; transcripts available in multiple Indic scripts. |
| **AI-Generated Chapters** | Chapters named for Indian context ("Auto wala scene", "Chai break point", "Cricket analogy"). |
| **Episode Summaries** | Summaries to determine relevance before listening; available in regional languages. |
| **Guest Identification** | AI identifies guests, shows bios, photos, and related episodes; spotlight on Indian podcasters, regional creators. |
| **Highlight Sharing** | Share snips via WhatsApp, Instagram, Telegram as voice notes or text with "Sunna chahta hai?" caption. |
| **Community Highlights** | Discover popular snippets from community members, filtered by city or language. |
| **YouTube Import** | Download YouTube audio (educational, comedy, news) for offline commute; supports multi-language tracks. |
| **Audiobook Import** | Upload Libro.fm audiobooks or local files (MP3). |
| **Chat Shortcuts** | Create custom prompts (summary, reflect, quiz) with one-tap activation. |
| **Post-Episode Chat** | Chat with episodes after listening for deeper engagement. |

### 2.2 Viral India Hooks (Beyond Snipd)

#### Hook 1: "Dangal" – Weekly Listening Wars
| Feature | Description | Virality Trigger |
|---------|-------------|------------------|
| Office/College Leaderboards | Auto-group by work email domain or college domain. | "Your IIT batch is losing to NIT" – competitive notifications. |
| Family Groups | Create family listening challenges. | "Mom listened more than you this week" – guilt + motivation. |
| City Championships | Top listener in each city gets featured on home screen. | "Mumbai's King of Commute" badge; city bragging rights. |
| Pahalwan Rankings | Tiered titles (Chotu → Ustaad → Maharathi) based on cumulative listening. | Status progression with local flavor. |

#### Hook 2: "Chai Pe Charcha" – Voice Reflections
| Feature | Description | Virality Mechanism |
|---------|-------------|---------------------|
| Post-Commute Voice Notes | Record 60-second reflection on what you learned. | Share to WhatsApp status with Kaan watermark and "Suno meri baat" sticker. |
| Community Wisdom Feed | Browse reflections from listeners in your city. | "Delhi is learning about..." trending topics; upvote best reflections. |
| Reaction Feature | React to others' reflections with voice notes. | Creates conversation chains; notifications when someone reacts. |
| Weekly Digest Video | Auto-compile best reflections into viral Reel. | "India's smartest commuters this week" – shareable on Instagram. |

#### Hook 3: "Gully Cricket" – Listening Streaks with Local Flavor
| Feature | Description | Virality Trigger |
|---------|-------------|------------------|
| Street Cred Score | Not just streak count, but "knowledge depth" score based on variety and retention. | Complex scoring system worth optimizing; displayed on profile. |
| Pados Ka Hero | Top listener in each pin code gets local fame. | "You're the most learned person in Andheri East" – push notification. |
| Chai Stall Leaderboard | Nearby listeners ranked – see at local tea stall via QR code. | QR code at partner chai stalls to join local league; real-world visibility. |
| Streak Insurance | Share with friend to protect streak if you miss a day. | Referral mechanic built into streak saving; friend gets bonus too. |

#### Hook 4: "Copy Cat" – Content Remixing
| Feature | Description | Viral Potential |
|---------|-------------|-----------------|
| Remix Highlights | Take any saved clip, add your voice commentary. | Create "reaction snippets" – share as Reels. |
| Duet Mode | Respond to someone else's reflection with your take. | Builds on existing content; chain reactions. |
| Meme Generator | Auto-generate meme from funny transcript moments. | One-tap share to Instagram with Kaan branding. |
| "Bhai Sun Na" Button | One-tap to send clip with pre-recorded "Bhai sun na yeh" intro (choose from popular voices). | Personal touch drives shares; viral loops. |

#### Hook 5: "Star Maker" – Creator Economy
| Feature | Description | Virality Trigger |
|---------|-------------|------------------|
| Top Contributors | Users with most upvoted reflections get verified badge. | Status + potential monetization. |
| Featured Voices | Best reflections featured on app home screen. | 15 minutes of fame; profile views. |
| Creator Partnerships | Invite top users to create official content. | Path from consumer to creator; revenue share. |
| Royalty Program | Share 10% of ad revenue with top reflection creators. | Financial incentive to create quality content. |

#### Hook 6: "Timepass" – Boredom Killers
| Feature | Description | Habit Formation |
|---------|-------------|-----------------|
| 5-Minute Micro-Lessons | Ultra-short content for short auto rides (e.g., "Learn one Sanskrit shloka"). | "Just 5 more minutes" addiction. |
| Quiz Mode | After listening, quick quiz to earn points. | Tests retention, rewards focus; share score. |
| "I'm Bored" Button | Shuffle ultra-engaging comedy/motivation clips from saved or trending. | Default option when bored; endless feed. |
| Sleep Timer with Twist | Falls asleep to educational content, wakes to AI-generated summary of what played. | Morning recap reinforces learning; feels magical. |

#### Hook 7: "Sabka Kaan" – Community Curation
| Feature | Description | Virality Mechanism |
|---------|-------------|---------------------|
| Community Highlights Tab | Most-snipped moments across all users. | "50 people saved this moment" – social proof. |
| Trending in Your City | Location-based trending content (podcasts, clips). | "What Pune is listening to" – local relevance. |
| Friend Activity Feed | See what friends are saving and reflecting on. | FOMO drives engagement; react to friends' activity. |
| Collaborative Playlists | Build commute mixes with friends (like Spotify Blend but for audio clips). | Group ownership increases stickiness. |

#### Hook 8: "Paise Wapsi" – Engagement Rewards
| Feature | Description | Retention Driver |
|---------|-------------|------------------|
| Kaan Coins | Earn coins for streaks, shares, reflections, referrals. | Virtual currency redeemable for premium features or partner vouchers. |
| Premium Giveaways | Top listeners each month win 1-year premium subscriptions. | Gamification of retention; leaderboard visibility. |
| Charity Donations | Convert listening time to micro-donations (e.g., 100 hours = plant a tree). | "Your 100 hours = 1 meal for a child" – social good hook. |
| Partner Discounts | Listening milestones unlock discounts at partner brands (Zomato, Myntra, etc.). | Real-world value from app usage; drives loyalty. |

---

## 3. User Stories & Acceptance Criteria

### US-01: Onboard new user
**As a** new user  
**I want** to set up my preferences quickly  
**So that** I get a personalized experience from day one.

**Acceptance Criteria:**
- User can enter commute duration via slider or manual input.
- User can select at least 3 interests from a grid of 12+ options.
- User can choose primary language(s) from a list of 8 Indian languages.
- User can preview and select a narrator voice.
- Progress bar fills as user completes each step.
- On final step, app generates a "Today's Mix" based on inputs and shows preview.
- Email signup option is available (not forced Google login).

### US-02: One-tap "Suno" save
**As a** listener  
**I want** to save interesting moments with a single tap  
**So that** I can revisit them later without interrupting my flow.

**Acceptance Criteria:**
- While listening, triple-tap headphones or say "Suno" triggers save.
- App saves last 30 seconds (configurable) with 10-second buffer before/after.
- AI generates title and summary within 5 seconds.
- Saved clip appears in Library with transcript and playback option.
- Works offline (queues save, syncs later).

### US-03: Ask Kaan (voice Q&A)
**As a** listener  
**I want** to ask questions about current content  
**So that** I can clarify concepts immediately.

**Acceptance Criteria:**
- Tap mic button or say "Kaan, bata" to activate.
- App records voice, transcribes, and sends to AI backend.
- AI responds in chosen language (Hinglish by default) within 3 seconds.
- Response appears as text with optional TTS playback.
- User can save Q&A pair to Library.

### US-04: Participate in Dangal (leaderboard)
**As a** competitive user  
**I want** to see how I rank against friends and city  
**So that** I am motivated to listen more.

**Acceptance Criteria:**
- Leaderboard shows this week's listening time for:
  - Friends (auto-grouped by phone contacts or work email domain)
  - City (top 10)
  - Overall (top 100)
- Current user's rank highlighted.
- Tapping a friend shows their profile, recent saves, reflections.
- Notifications when someone overtakes you.

### US-05: Record a Chai Break reflection
**As a** user  
**I want** to share what I learned  
**So that** I can reinforce my learning and connect with others.

**Acceptance Criteria:**
- After 30 mins of continuous listening, a "Chai Break" modal appears.
- User can record up to 60 seconds voice reflection.
- Reflection is transcribed and posted to Community Wisdom Feed (public by default, can set to friends-only).
- Friends can react with voice or emoji.
- Reflection can be shared to WhatsApp/Instagram with one tap.

### US-06: Earn Kaan Coins
**As a** user  
**I want** to earn rewards for my engagement  
**So that** I feel valued and get perks.

**Acceptance Criteria:**
- Coins awarded for: daily login (10), streak day (20), reflection shared (15), referral (100), etc.
- Coin balance visible on profile.
- Store section to redeem coins: premium days, partner discounts, charity donations.
- Push notification when new coins earned.

### US-07: Remix a clip
**As a** creative user  
**I want** to add my commentary to a saved clip  
**So that** I can create funny or insightful content.

**Acceptance Criteria:**
- From Library, select clip and tap "Remix".
- Record voice commentary while original clip plays in background.
- New remix saved as separate clip, can be shared.
- If shared, original user gets notification and share of karma (coins).

### US-08: Join a Collaborative Playlist
**As a** user  
**I want** to build a commute mix with friends  
**So that** we can share the listening experience.

**Acceptance Criteria:**
- Create a collaborative playlist, invite friends via WhatsApp.
- Each member can add clips from their Library or Discovery.
- Playlist plays in sequence during commute; members see who added what.
- Weekly summary: "Your friend Priya added 5 clips this week".

---

## 4. Technical Requirements

### 4.1 Platform & Framework
- **Mobile**: iOS 14+, Android 6.0+ via **Flutter 3.24+**
- **Web**: Flutter for web compiled to JavaScript, delivered as a PWA with offline support (service workers)
- **Backend**: Node.js 20+ (Express/Fastify) with TypeScript
- **Database**: PostgreSQL 15 (user data, social graphs) + MongoDB (content catalog, transcripts)
- **Real-time**: WebSockets (Socket.io) for leaderboards, activity feeds, collaborative playlists
- **Cache**: Redis for session management, leaderboard rankings, rate limiting
- **File storage**: AWS S3 / Cloudflare R2 for audio files, transcripts, user-generated content
- **CDN**: Cloudflare for low-latency audio streaming globally

### 4.2 AI Services (Managed)
| Service | Purpose | Provider | Notes |
|---------|---------|----------|-------|
| **LLM (Q&A, summaries)** | GPT-5 (OpenAI) | Primary for Indian language support, Hinglish fluency | |
| **LLM (summarization, long-form)** | Claude Sonnet 4.6 via AWS Bedrock | Secondary for 1M context, cost-effective for batch jobs | |
| **Speech-to-Text** | Whisper API (OpenAI) | Supports Indian accents, multiple languages | |
| **Text-to-Speech** | Amazon Polly | Indian English, Hindi, Tamil, Telugu voices; neural TTS | |
| **Content Moderation** | OpenAI Moderation API | Filter reflections, comments | |
| **Embeddings** | OpenAI Embeddings | For recommendation engine | |

### 4.3 Flutter Frontend Details

#### 4.3.1 State Management
- **Riverpod 2.5+** (compile-time safety, easy testing, reactive UI)

#### 4.3.2 Navigation
- **go_router 14.0+** – declarative routing with deep linking, nested navigation, PWA URL support

#### 4.3.3 Audio Playback
- **just_audio 0.9.36+** – core streaming, caching, playlists
- **audio_service 0.18.12+** – background audio, lock screen controls (mobile), media session for web
- **Web support**: `just_audio_web` plugin; service worker for offline caching

#### 4.3.4 Local Storage & Offline
- **Local database**: **Isar 3.1+** (NoSQL, fast, supports complex queries, full-text search)
- **Key-value**: `shared_preferences` + `flutter_secure_storage` for tokens
- **File caching**: `path_provider` + `dio` with `cached_audio`; background download via `workmanager` (mobile) and service worker (web)
- **Offline sync**: `workmanager` (mobile) and `background_fetch` (web) to sync when connectivity restored

#### 4.3.5 Push Notifications (Mobile)
- **Firebase Cloud Messaging** via `firebase_messaging`
- **Local notifications**: `flutter_local_notifications` for reminders, streak alerts

#### 4.3.6 Web-Specific
- **PWA manifest**: Configure for installability, splash screens, theme colors
- **Service workers**: Auto-generated by Flutter; custom caching strategy for audio files
- **Responsive design**: Use `LayoutBuilder` and `MediaQuery` to adapt to desktop/tablet

#### 4.3.7 Networking
- **Dio** – HTTP client with interceptors, retries, cancellation
- **web_socket_channel** – real-time WebSocket communication

#### 4.3.8 Analytics & Crash Reporting
- **PostHog** (`posthog_flutter`) – product analytics, self-hostable
- **Sentry** (`sentry_flutter`) – crash reporting

#### 4.3.9 Performance Optimisation
- Use `ListView.builder` with item recycling
- Offload heavy computations to isolates (`compute`)
- Image caching with `cached_network_image`
- Flutter build with `--split-debug-info` and obfuscation to reduce size

### 4.4 Backend (Node.js)
- **API**: Express.js + TypeScript, REST endpoints + WebSocket handlers
- **Database ORM**: Prisma (PostgreSQL), Mongoose (MongoDB)
- **Authentication**: JWT with OTP via MSG91/Twilio; social login (Google, Facebook) optional
- **File upload**: Multer to S3 with signed URLs
- **Queue**: BullMQ (Redis) for async tasks: audio processing, AI summarization, email digests
- **Cron jobs**: Node-cron for daily challenge reset, leaderboard calculations, email digests

### 4.5 Infrastructure
- **Cloud**: AWS Mumbai region (ap-south-1) for low latency and data residency
- **Containerization**: Docker, orchestration via ECS Fargate or Kubernetes (EKS)
- **CI/CD**: GitHub Actions (build, test, deploy)
- **Monitoring**: Prometheus + Grafana (metrics), ELK stack (logs), Sentry (errors)

---

## 5. Habit-Forming UX Design (The Hook Model)

### 5.1 Trigger
- **External**: Push notification 15 min before usual commute time ("Your mix is ready, Raj").
- **External**: Friend activity notification ("Priya just saved a clip from 'The Practice'").
- **External**: Daily challenge reminder ("Today's challenge: Learn one Sanskrit shloka").
- **Internal**: Boredom during commute, guilt of wasted time, curiosity about trending content.

### 5.2 Action
- **Minimal friction**: One tap "Start Commute Mode" from home screen or lock screen widget.
- **Friction removed**: Playlist is ready; no searching, no decisions.
- **Contextual**: Audio starts instantly; user can preview and adjust if desired.
- **Voice activation**: "Hey Kaan, play my commute" works even when phone is locked.

### 5.3 Variable Reward
- **Content variety**: Mix of educational, funny, news – unpredictable but curated.
- **Social reward**: Leaderboard position, friend likes on reflections, "Pados Ka Hero" title.
- **Achievement reward**: Badges, level-ups, daily challenges completed, Kaan Coins.
- **Knowledge reward**: "Ask Kaan" gives instant answers; quiz mode tests retention.
- **Community reward**: Seeing your reflection featured or upvoted.

### 5.4 Investment
- **Saved clips**: User builds a personal library of wisdom; switching cost increases.
- **Reflections**: User contributes content, creating a sense of ownership and identity.
- **Streak**: User invests time daily; loss aversion ("Don't break your 30-day streak!").
- **Friends & followers**: Social graph locks user in; collaborative playlists require group participation.
- **Learned topics**: Progress bars show mastery; user feels invested in completing topics.
- **Kaan Coins**: Accumulated virtual currency creates sunk cost.

---

## 6. Viral Growth Mechanics

### 6.1 Inherent Virality
- **Reflections sharing**: One-tap share to WhatsApp/Instagram with Kaan watermark; friends curious to join.
- **Dangal leaderboard challenges**: "I challenge you to a listening duel" – invites via WhatsApp.
- **Streak insurance**: To protect streak, user must invite a friend (who then gets bonus).
- **Collaborative playlists**: Invite friends to contribute; group activity drives sign-ups.

### 6.2 Social Proof Triggers
- **"Your friend Priya is listening to..."** notifications.
- **"Join your office leaderboard"** – auto-group by work email; see how many colleagues already on Kaan.
- **"Trending in your city"** – local content creates community FOMO.
- **"50 people saved this moment"** – social proof on community highlights.

### 6.3 Content Virality
- **Remix & Duet**: Users create derivative content that credits original source; drives network effects.
- **Meme generator**: Funny transcript moments turned into memes; share with Kaan branding.
- **Weekly digest video**: Auto-compiled best reflections; shareable on Instagram, tagged #KaanIndia.

### 6.4 Gamified Referrals
- **Referral leaderboard**: "Top 10 referrers this month get 1 year premium."
- **Dual-sided incentive**: Referrer gets 100 Kaan Coins, referee gets 50 coins on sign-up.
- **Streak insurance** as referral mechanic: "Protect your streak by inviting a friend."

### 6.5 Real-World Integration
- **Chai stall QR codes**: Scan to join local leaderboard; physical presence drives word-of-mouth.
- **College campus ambassador program**: Students promote Kaan in exchange for premium access.

---

## 7. Aesthetic & UX Guidelines

### 7.1 Visual Identity
- **Primary color**: #FF6B35 (warm orange) – evokes energy, chai, sunset.
- **Secondary**: #2E4057 (deep slate) – stable, readable.
- **Accent**: #4ECDC4 (mint) – success, progress.
- **Background**: #FDF8F2 (warm off-white) for light mode; #1A1E24 for dark mode.
- **Typography**: Use `google_fonts` for Satoshi (headings) and Inter (body); fallback to system fonts.
- **Iconography**: Custom line icons with rounded corners, 2px stroke; support for Indian cultural symbols (auto, chai, etc.).

### 7.2 Micro-interactions
- **Button taps**: Scale to 0.98 with spring animation (using `AnimatedContainer`).
- **Progress bars**: Smooth easing curves with `TweenAnimationBuilder`.
- **Swipe gestures**: `Dismissible` for removing items; haptic feedback on mobile.
- **Pull to refresh**: Custom ear-wave animation using `CustomPainter`.
- **Achievement unlock**: Confetti animation + haptic.

### 7.3 Accessibility
- **Semantic labels** for screen readers (TalkBack/VoiceOver).
- **Contrast ratios** meeting WCAG AA (4.5:1 for text).
- **Text scaling** according to device settings.
- **Closed captions/transcripts** for all audio content (optional toggle).

### 7.4 Performance Targets
- **App launch time** < 2 seconds on mid-range devices (Redmi Note series).
- **Audio start time** < 1 second after tapping play.
- **Smooth 60fps scrolling** in lists (Library, Discovery).
- **Offline mode** fully functional without internet (cached content).
- **Web PWA** loads core UI in < 3 seconds on 3G.

---

## 8. Tech Stack Summary

| Layer | Technology |
|-------|------------|
| **Frontend (Mobile & Web)** | Flutter 3.24+ |
| **State Management** | Riverpod 2.5+ |
| **Navigation** | go_router 14.0+ |
| **Audio Playback** | just_audio + audio_service |
| **Local Database** | Isar 3.1+ |
| **Local Storage** | shared_preferences + flutter_secure_storage |
| **Background Tasks** | workmanager (mobile), service workers (web) |
| **Push Notifications** | Firebase Cloud Messaging + flutter_local_notifications |
| **Networking** | Dio + web_socket_channel |
| **Analytics** | PostHog (self-hosted) |
| **Crash Reporting** | Sentry |
| **Backend** | Node.js + Express + TypeScript |
| **Databases** | PostgreSQL (user, social), MongoDB (content) |
| **Real-time** | Socket.io (Redis) |
| **Queues** | BullMQ (Redis) |
| **AI Services** | OpenAI (GPT-5, Whisper, Embeddings), Claude (via AWS Bedrock), Amazon Polly |
| **Cloud Infrastructure** | AWS Mumbai (EC2, ECS, RDS, S3, Bedrock) |
| **CDN** | Cloudflare |
| **Monitoring** | Prometheus + Grafana, ELK, Sentry |

---

## 9. Development Phases

### Phase 1: MVP (Months 1-3)
**Goal**: Core listening experience with Snipd features, offline, basic personalization.

| Deliverable | Tech |
|-------------|------|
| Onboarding flow | Flutter UI, Riverpod |
| Home screen with "Start Commute Mode" | just_audio integration |
| Basic audio player (play/pause, skip, speed) | audio_service for background |
| "Suno" save (headphone tap) | Platform channels for headphone detection |
| AI summaries (Hinglish only) | OpenAI GPT-5 (minimal usage) |
| Local library (saved clips) | Isar storage |
| Offline playback | Caching with path_provider |
| Web PWA with core features | Flutter web build, service worker |

**Success Metrics**: 1,000 DAU, Day 7 retention > 30%, snip save rate > 2 per user/week.

### Phase 2: Personalization & AI (Months 4-5)
**Goal**: Intelligent recommendations, voice Q&A, regional language support.

| Deliverable | Tech |
|-------------|------|
| "For You" recommendations | OpenAI embeddings + custom ML |
| "Ask Kaan" voice Q&A | Whisper + GPT-5 + Polly TTS |
| Regional language summaries | Prompt engineering for 8 languages |
| Episode summaries & chapters | Claude (batch via Bedrock) |
| Transcripts with sync | WebSocket for real-time sync; fix accuracy |
| Email/WhatsApp digests | BullMQ + cron jobs |

**Success Metrics**: MAU 10,000, "Ask Kaan" usage > 3 queries/user/week, regional language adoption > 30%.

### Phase 3: Social & Gamification (Months 6-7)
**Goal**: Viral hooks, community features, engagement loops.

| Deliverable | Tech |
|-------------|------|
| Dangal leaderboards | PostgreSQL + Redis sorted sets |
| Chai Pe Charcha reflections | S3 for audio, moderation API |
| Streak system + Street Cred | Isar local + server sync |
| Kaan Coins economy | PostgreSQL transactions |
| Community Highlights tab | MongoDB aggregation |
| Collaborative playlists | WebSocket for real-time updates |
| Copy Cat remixing | Audio editing backend (FFmpeg) |
| Meme generator | ImageMagick + templates |

**Success Metrics**: Viral coefficient > 0.3, reflections shared > 25% of active users, DAU/MAU > 40%.

### Phase 4: Monetization & Scale (Months 8-9)
**Goal**: Revenue generation, creator economy, partnerships.

| Deliverable | Tech |
|-------------|------|
| Premium subscriptions | Razorpay integration |
| Kaan Coins store | Redeem for premium days, partner discounts |
| Creator program (Star Maker) | Featured voices algorithm, revenue share |
| Brand partnerships | API for sponsored content |
| Partner discounts API | Integration with Zomato, Myntra, etc. |
| Charity donations | NGO partnerships, impact tracking |
| Performance optimization | CDN tuning, database indexing, caching |

**Success Metrics**: Subscription conversion > 5% of active users, ARPU > ₹20/month, NPS > 50.

---

## 10. Edge Cases & Error Handling

| Scenario | Handling |
|----------|----------|
| No internet during commute | Play cached mix if available; show offline indicator; prompt to download over WiFi next time. |
| Insufficient storage | Warn user; allow selective deletion of saved clips/offline content. |
| Battery optimization (mobile) | Request battery optimization exemption; use efficient audio codecs. |
| Call interruption (mobile) | Pause audio automatically, resume after call ends. |
| Poor network | Auto-switch to low-bitrate stream (32kbps); allow manual quality selection. |
| Content not available in selected language | Fallback to Hinglish/English with notification; offer to translate. |
| Transcript-audio sync inaccurate | Collect feedback; use that data to fine-tune AI boundaries. |
| User skips onboarding | Force completion; cannot access home screen. |
| Web autoplay restrictions | Require user interaction (tap "Start") before playing audio; show prompt. |
| Service worker updates (web) | Prompt user to refresh for new version; cache invalidation strategy. |

---

## 11. Security & Privacy

- **Data encryption**: All personal data encrypted at rest (AES-256) and in transit (TLS 1.3).
- **Authentication**: OTP only (no password storage); optional social login with OAuth.
- **Contact sync**: Only with explicit permission; hashed emails/phones for matching; never stored plaintext.
- **Content moderation**: AI moderation (OpenAI Moderation API) + human review for flagged reflections.
- **User control**: GDPR-compliant data export and deletion; ability to anonymize past reflections.
- **Payment data**: Handled by Razorpay; no card storage on our servers; PCI-DSS compliant.
- **Anonymity option**: Users can post reflections anonymously (identity hidden but still earn coins).

---

## 12. Success Metrics (KPIs)

| Category | Metric | Target |
|----------|--------|--------|
| **Acquisition** | Downloads | 100k in first 6 months |
| | Viral coefficient (K-factor) | > 0.3 |
| **Engagement** | DAU/MAU | > 40% |
| | Average listening time per DAU | > 45 min/day |
| | Streak completion rate (30 days) | > 40% |
| | Reflection share rate | > 25% of active users |
| **Retention** | Day 1 / Day 7 / Day 30 retention | 60% / 45% / 30% |
| **Monetization** | Conversion to premium | > 5% of MAU |
| | Average Revenue Per Paying User (ARPPU) | ₹200/month |
| | Kaan Coins redemption rate | > 20% of earned coins |
| **Satisfaction** | Net Promoter Score (NPS) | > 50 |
| | App Store rating | > 4.5 |

---

## 13. Conclusion

Kaan is designed to be the ultimate companion for India's commuters – combining the AI-powered knowledge tools of Snipd with viral hooks that tap into Indian culture, competition, and social sharing. By building with Flutter for mobile and web, we ensure maximum reach and a consistent experience. The phased development plan allows us to validate core features first, then layer on engagement mechanics and monetization.

With a clear focus on habit formation (Hook Model), viral growth (engineered sharing), and local relevance (regional languages, cultural references), Kaan is poised to become a daily ritual for millions and a venture-scale business.

---

**Next Steps:** 
1. Finalize product branding and design system.
2. Set up Flutter project with Riverpod and go_router.
3. Implement Phase 1 MVP (3 months).
4. Launch beta in Bangalore and Mumbai for initial feedback.

*This document is a living spec and should be updated as development progresses and user feedback is incorporated.*
