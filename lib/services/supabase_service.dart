import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/models.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final episodeFeedProvider = FutureProvider.family<List<Episode>, String?>((ref, category) async {
  return ref.watch(supabaseServiceProvider).getFeed(category: category);
});

final trendingEpisodesProvider = FutureProvider<List<Episode>>((ref) async {
  return ref.watch(supabaseServiceProvider).getTrending();
});

final savedClipsProvider = FutureProvider<List<SavedClip>>((ref) async {
  return ref.watch(supabaseServiceProvider).getSavedClips();
});

final reflectionsProvider = FutureProvider.family<List<Reflection>, String?>((ref, city) async {
  return ref.watch(supabaseServiceProvider).getReflections(city: city);
});

/// Supabase service for all backend operations
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get _client => Supabase.instance.client;

  // ============ AUTH ============

  Future<void> signInWithOtp(String phone) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  Future<AuthResponse> verifyOtp(String phone, String token) async {
    return await _client.auth.verifyOTP(phone: phone, token: token, type: OtpType.sms);
  }

  Future<AuthResponse> signInWithGoogle() async {
    // For Google Sign-In, typically done via the auth UI
    throw UnimplementedError('Use Supabase Auth UI for Google sign in');
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  // ============ PROFILES ============

  Future<UserProfile?> getProfile() async {
    if (currentUser == null) return null;
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', currentUser!.id)
        .single();
    return UserProfile.fromJson(data);
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    await _client
        .from('profiles')
        .update(updates)
        .eq('id', currentUser!.id);
  }

  Future<void> completeOnboarding({
    required List<String> languages,
    required List<String> interests,
    required int commuteDuration,
    required String preferredVoice,
  }) async {
    await updateProfile({
      'languages': languages,
      'interests': interests,
      'commute_duration_min': commuteDuration,
      'preferred_voice': preferredVoice,
      'onboarding_completed': true,
    });
  }

  // ============ EPISODES ============

  Future<List<Episode>> getFeed({String? category, int limit = 20}) async {
    var query = _client
        .from('episodes')
        .select('*, podcasts(title, image_url)');

    if (category != null) {
      query = query.eq('category', category);
    }

    final data = await query
        .order('published_at', ascending: false)
        .limit(limit);
    return data.map<Episode>((e) => Episode.fromJson(e)).toList();
  }

  Future<List<Episode>> getTrending({int limit = 10}) async {
    final data = await _client
        .from('episodes')
        .select()
        .order('save_count', ascending: false)
        .limit(limit);
    return data.map<Episode>((e) => Episode.fromJson(e)).toList();
  }

  Future<List<Episode>> searchEpisodes(String query) async {
    final data = await _client
        .from('episodes')
        .select()
        .or('title.ilike.%$query%,description.ilike.%$query%')
        .order('published_at', ascending: false)
        .limit(20);
    return data.map<Episode>((e) => Episode.fromJson(e)).toList();
  }

  Future<Episode> importYouTubeEpisode({
    required String title,
    required String author,
    required String audioUrl,
    required String imageUrl,
    required int durationSeconds,
    String? description,
  }) async {
    // 1. Find or create a 'YouTube Import' podcast
    final podcastData = await _client
        .from('podcasts')
        .select()
        .eq('title', 'YouTube Imports')
        .maybeSingle();

    String podcastId;
    if (podcastData == null) {
      final newPodcast = await _client.from('podcasts').insert({
        'title': 'YouTube Imports',
        'author': 'YouTube',
        'description': 'Podcasts imported from YouTube videos',
        'image_url': 'https://www.youtube.com/s/desktop/281f33f6/img/favicon_144x144.png',
      }).select().single();
      podcastId = newPodcast['id'];
    } else {
      podcastId = podcastData['id'];
    }

    // 2. Insert the episode
    final episodeData = await _client.from('episodes').insert({
      'podcast_id': podcastId,
      'title': title,
      'description': description ?? 'Imported from YouTube',
      'audio_url': audioUrl,
      'image_url': imageUrl,
      'duration_seconds': durationSeconds,
      'category': 'YouTube',
      'published_at': DateTime.now().toIso8601String(),
    }).select().single();

    return Episode.fromJson(episodeData);
  }

  // ============ SAVED CLIPS ============

  Future<void> saveClip({
    required String episodeId,
    required int startSeconds,
    required int endSeconds,
    String? aiTitle,
    String? aiSummary,
    String? transcript,
  }) async {
    await _client.from('saved_clips').insert({
      'user_id': currentUser!.id,
      'episode_id': episodeId,
      'start_seconds': startSeconds,
      'end_seconds': endSeconds,
      'ai_title': aiTitle,
      'ai_summary': aiSummary,
      'transcript': transcript,
    });

    // Increment save count on episode
    await _client.rpc('increment_save_count', params: {'episode_id_param': episodeId});

    // Award coins for saving
    await awardCoins(5, 'Saved a clip 📌');
  }

  Future<List<SavedClip>> getSavedClips() async {
    final data = await _client
        .from('saved_clips')
        .select('*, episodes(title, podcast_id, podcasts(title, image_url))')
        .eq('user_id', currentUser!.id)
        .order('saved_at', ascending: false);
    return data.map<SavedClip>((e) => SavedClip.fromJson(e)).toList();
  }

  Future<void> deleteClip(String clipId) async {
    await _client.from('saved_clips').delete().eq('id', clipId);
  }

  // ============ REFLECTIONS ============

  Future<void> createReflection({
    String? episodeId,
    String? audioUrl,
    required String transcript,
    required int durationSeconds,
    required bool isPublic,
  }) async {
    final profile = await getProfile();
    await _client.from('reflections').insert({
      'user_id': currentUser!.id,
      'episode_id': episodeId,
      'audio_url': audioUrl,
      'transcript': transcript,
      'duration_seconds': durationSeconds,
      'city': profile?.city ?? 'Unknown',
      'is_public': isPublic,
    });

    // Award coins for sharing reflection
    await awardCoins(15, 'Shared a reflection ☕');
  }

  Future<List<Reflection>> getReflections({String? city, int limit = 20}) async {
    var query = _client
        .from('reflections')
        .select('*, profiles(name, avatar_url)')
        .eq('is_public', true);

    if (city != null) {
      query = query.eq('city', city);
    }

    final data = await query
        .order('created_at', ascending: false)
        .limit(limit);
    return data.map<Reflection>((e) => Reflection.fromJson({
          ...e,
          'user_name': e['profiles']?['name'] ?? 'Anonymous',
          'user_avatar_url': e['profiles']?['avatar_url'],
        })).toList();
  }

  Future<void> upvoteReflection(String reflectionId) async {
    await _client.from('reflection_reactions').upsert({
      'reflection_id': reflectionId,
      'user_id': currentUser!.id,
      'type': 'upvote',
    });
  }

  // ============ KAAN COINS ============

  Future<void> awardCoins(int amount, String reason) async {
    await _client.from('coin_transactions').insert({
      'user_id': currentUser!.id,
      'type': 'earned',
      'amount': amount,
      'reason': reason,
    });

    // Update profile balance
    final profile = await getProfile();
    if (profile != null) {
      await updateProfile({'kaan_coins': profile.kaanCoins + amount});
    }
  }

  Future<void> spendCoins(int amount, String reason) async {
    await _client.from('coin_transactions').insert({
      'user_id': currentUser!.id,
      'type': 'spent',
      'amount': -amount,
      'reason': reason,
    });

    final profile = await getProfile();
    if (profile != null) {
      await updateProfile({'kaan_coins': profile.kaanCoins - amount});
    }
  }

  Future<List<CoinTransaction>> getCoinHistory() async {
    final data = await _client
        .from('coin_transactions')
        .select()
        .eq('user_id', currentUser!.id)
        .order('created_at', ascending: false)
        .limit(50);
    return data.map<CoinTransaction>((e) => CoinTransaction.fromJson(e)).toList();
  }

  // ============ STREAKS ============

  Future<void> recordListeningDay({required int minutes}) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    await _client.from('streak_records').upsert({
      'user_id': currentUser!.id,
      'date': today,
      'listening_minutes': minutes,
    });
  }

  // ============ LEADERBOARD ============

  Future<List<LeaderboardEntry>> getLeaderboard({String? city, int limit = 20}) async {
    var query = _client
        .from('leaderboard_weekly')
        .select('*, profiles(name, avatar_url, pahalwan_rank, street_cred_score)');

    if (city != null) {
      query = query.eq('city', city);
    }

    final data = await query
        .order('listening_minutes', ascending: false)
        .limit(limit);
    return data.asMap().entries.map<LeaderboardEntry>((entry) {
      final e = entry.value;
      return LeaderboardEntry.fromJson({
        'rank': entry.key + 1,
        'user_id': e['user_id'],
        'user_name': e['profiles']?['name'] ?? 'Unknown',
        'user_avatar_url': e['profiles']?['avatar_url'],
        'listening_minutes': e['listening_minutes'],
        'pahalwan_rank': e['profiles']?['pahalwan_rank'] ?? 'Chotu',
        'street_cred_score': e['profiles']?['street_cred_score'] ?? 0,
      }, isCurrentUser: e['user_id'] == currentUser?.id);
    }).toList();
  }

  // ============ PLAYLISTS ============

  Future<void> createPlaylist({
    required String name,
    String? description,
    bool isCollaborative = false,
  }) async {
    final playlist = await _client.from('playlists').insert({
      'name': name,
      'description': description,
      'created_by': currentUser!.id,
      'is_collaborative': isCollaborative,
    }).select().single();

    // Add creator as owner
    await _client.from('playlist_members').insert({
      'playlist_id': playlist['id'],
      'user_id': currentUser!.id,
      'role': 'owner',
    });
  }

  // ============ LISTENING HISTORY ============

  Future<void> recordListening({
    required String episodeId,
    required int progressSeconds,
    bool completed = false,
  }) async {
    await _client.from('listening_history').insert({
      'user_id': currentUser!.id,
      'episode_id': episodeId,
      'progress_seconds': progressSeconds,
      'completed': completed,
    });
  }

  // ============ REALTIME ============

  RealtimeChannel subscribeToReflections(void Function(Map<String, dynamic>) onData) {
    return _client.channel('reflections').onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'reflections',
      callback: (payload) => onData(payload.newRecord),
    ).subscribe();
  }

  RealtimeChannel subscribeToLeaderboard(void Function(Map<String, dynamic>) onData) {
    return _client.channel('leaderboard').onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'leaderboard_weekly',
      callback: (payload) => onData(payload.newRecord),
    ).subscribe();
  }
}
