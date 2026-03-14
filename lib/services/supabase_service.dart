import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../core/models/models.dart';
import '../core/data/sample_data.dart';
import '../core/constants/app_constants.dart';

// Providers for the service
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
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
    return await _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  Future<AuthResponse> signInWithGoogle() async {
    // For Google Sign-In, typically done via the auth UI
    throw UnimplementedError('Use Supabase Auth UI for Google sign in');
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localProfileKey);
      print('Sign out successful');
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  // ============ PROFILES ============

  static const String _localProfileKey = 'local_guest_profile';

  Future<UserProfile?> getProfile() async {
    if (currentUser == null) {
      // Try to load from SharedPreferences first
      try {
        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString(_localProfileKey);
        if (stored != null) {
          final Map<String, dynamic> json = jsonDecode(stored);
          return UserProfile(
            id: 'temp-local-id',
            name: 'Guest User',
            languages: List<String>.from(json['languages'] ?? ['en']),
            interests: List<String>.from(json['interests'] ?? []),
            commuteDurationMin: json['commuteDurationMin'] as int? ?? 45,
            onboardingCompleted: json['onboardingCompleted'] as bool? ?? true,
            createdAt: DateTime.now(),
          );
        }
      } catch (e) {
        print('Error loading local profile: $e');
      }

      // Return default mock profile if nothing is stored
      return UserProfile(
        id: 'temp-local-id',
        name: 'Guest User',
        languages: const ['en'],
        interests: const [],
        commuteDurationMin: 45,
        onboardingCompleted: false,
        createdAt: DateTime.now(),
      );
    }
    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();
      return UserProfile.fromJson(data);
    } catch (e) {
      print('Failed to fetch profile: $e');
      return null;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (currentUser == null) {
      // Save locally if not authenticated
      try {
        final prefs = await SharedPreferences.getInstance();
        final currentProfile = await getProfile();
        if (currentProfile != null) {
          final Map<String, dynamic> newProfileData = {
            'languages': updates.containsKey('languages')
                ? updates['languages']
                : currentProfile.languages,
            'interests': updates.containsKey('interests')
                ? updates['interests']
                : currentProfile.interests,
            'commuteDurationMin': updates.containsKey('commute_duration_min')
                ? updates['commute_duration_min']
                : currentProfile.commuteDurationMin,
            'onboardingCompleted': updates.containsKey('onboarding_completed')
                ? updates['onboarding_completed']
                : currentProfile.onboardingCompleted,
          };
          await prefs.setString(_localProfileKey, jsonEncode(newProfileData));
        }
      } catch (e) {
        print('Failed to save local profile: $e');
      }
      return;
    }

    try {
      await _client.from('profiles').update(updates).eq('id', currentUser!.id);
    } catch (e) {
      print('Failed to update profile: $e');
    }
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
    try {
      if (AppConstants.supabaseUrl.isEmpty) {
        throw Exception('Supabase URL is empty');
      }
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
    } catch (e) {
      print('Supabase getFeed failed, using SampleData: $e');
      return SampleData.sampleEpisodes.take(limit).toList();
    }
  }

  Future<List<Episode>> getTrending({int limit = 10}) async {
    try {
      if (AppConstants.supabaseUrl.isEmpty) {
        throw Exception('Supabase URL is empty');
      }
      final data = await _client
          .from('episodes')
          .select()
          .order('save_count', ascending: false)
          .limit(limit);
      return data.map<Episode>((e) => Episode.fromJson(e)).toList();
    } catch (e) {
      print('Supabase getTrending failed, using SampleData: $e');
      return SampleData.sampleEpisodes.take(limit).toList();
    }
  }

  Future<List<Episode>> searchEpisodes(String query) async {
    try {
      if (AppConstants.supabaseUrl.isEmpty) {
        throw Exception('Supabase URL is empty');
      }
      final data = await _client
          .from('episodes')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .order('published_at', ascending: false)
          .limit(20);
      return data.map<Episode>((e) => Episode.fromJson(e)).toList();
    } catch (e) {
      print('Supabase searchEpisodes failed, using SampleData fallback: $e');
      return SampleData.sampleEpisodes
          .where((ep) => 
              ep.title.toLowerCase().contains(query.toLowerCase()) || 
              ep.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<Episode> importYouTubeEpisode(String youtubeUrl) async {
    try {
      final response = await _client.functions.invoke(
        'import-youtube',
        body: {'youtubeUrl': youtubeUrl},
      );

      final data = response.data;
      if (data != null && data['success'] == true) {
        return Episode.fromJson(data['episode']);
      } else {
        throw Exception(data?['error'] ?? 'Failed to import YouTube video');
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        print(
          'YouTube Import Failed with 401: Ensure function is deployed with --no-verify-jwt',
        );
      }
      print('Failed to import YouTube video: $e');
      rethrow;
    }
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
    await _client.rpc(
      'increment_save_count',
      params: {'episode_id_param': episodeId},
    );

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

  Future<List<Reflection>> getReflections({
    String? city,
    int limit = 20,
  }) async {
    try {
      if (AppConstants.supabaseUrl.isEmpty) {
        throw Exception('Supabase URL is empty');
      }
      var query = _client
          .from('reflections')
          .select('*, profiles(name, avatar_url)')
          .eq('is_public', true);

      if (city != null) {
        query = query.eq('city', city);
      }

      final data = await query.order('created_at', ascending: false).limit(limit);
      return data
          .map<Reflection>(
            (e) => Reflection.fromJson({
              ...e,
              'user_name': e['profiles']?['name'] ?? 'Anonymous',
              'user_avatar_url': e['profiles']?['avatar_url'],
            }),
          )
          .toList();
    } catch (e) {
      print('Supabase getReflections failed, using SampleData: $e');
      return SampleData.sampleReflections.take(limit).toList();
    }
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
    return data
        .map<CoinTransaction>((e) => CoinTransaction.fromJson(e))
        .toList();
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

  Future<List<LeaderboardEntry>> getLeaderboard({
    String? city,
    int limit = 20,
  }) async {
    var query = _client
        .from('leaderboard_weekly')
        .select(
          '*, profiles(name, avatar_url, pahalwan_rank, street_cred_score)',
        );

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
    final playlist = await _client
        .from('playlists')
        .insert({
          'name': name,
          'description': description,
          'created_by': currentUser!.id,
          'is_collaborative': isCollaborative,
        })
        .select()
        .single();

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

  RealtimeChannel subscribeToReflections(
    void Function(Map<String, dynamic>) onData,
  ) {
    return _client
        .channel('reflections')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'reflections',
          callback: (payload) => onData(payload.newRecord),
        )
        .subscribe();
  }

  RealtimeChannel subscribeToLeaderboard(
    void Function(Map<String, dynamic>) onData,
  ) {
    return _client
        .channel('leaderboard')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'leaderboard_weekly',
          callback: (payload) => onData(payload.newRecord),
        )
        .subscribe();
  }

  // ============ EXTERNAL PODCAST INTEGRATION ============

  Future<List<PodcastSearchResult>> searchExternalPodcasts(
    String query, {
    String provider = 'itunes',
  }) async {
    try {
      final response = await _client.functions.invoke(
        'search-podcasts',
        body: {'query': query, 'provider': provider},
      );

      final data = response.data;
      if (data != null && data['success'] == true) {
        final resultsList = data['results'] as List;
        return resultsList.map((e) => PodcastSearchResult.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      if (e.toString().contains('401')) {
        print(
          'Podcast Search Failed with 401: This usually means the Edge Function needs to be deployed with --no-verify-jwt',
        );
      }
      print('Failed to search external podcasts: $e');
      if (e.toString().contains('401')) {
        throw Exception('Access Denied (401): Ensure the search-podcasts Edge Function is deployed with --no-verify-jwt');
      } else if (e.toString().contains('404')) {
        throw Exception('Function Not Found (404): Ensure the search-podcasts Edge Function is deployed');
      }
      rethrow; // Rethrow so UI can show the error
    }
  }

  Future<List<Episode>> syncAndGetEpisodes(
    String rssUrl, {
    String? category,
  }) async {
    try {
      print('Calling sync-podcast Edge Function for: $rssUrl');
      final response = await _client.functions.invoke(
        'sync-podcast',
        body: {'rssUrl': rssUrl, 'category': category ?? 'General'},
      );

      final data = response.data;
      if (data != null && data['success'] == true) {
        final podcastId = data['podcast']['id'];
        print('Podcast synced successfully. ID: $podcastId.');
        
        final List<dynamic> episodesJson = data['episodes'] ?? [];
        return episodesJson.map<Episode>((e) => Episode.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('SYNC ERROR TYPE: ${e.runtimeType}');
      if (e is PostgrestException) {
        print('Postgrest Error: ${e.message} (Code: ${e.code})');
      }
      if (e.toString().contains('401')) {
        print(
          'Sync Podcast Failed with 401: Ensure function is deployed with --no-verify-jwt',
        );
      }
      print('Failed to sync podcast: $e');
      if (e.toString().contains('401')) {
        throw Exception('Access Denied (401): Ensure the sync-podcast Edge Function is deployed with --no-verify-jwt');
      }
      rethrow;
    }
  }
}
