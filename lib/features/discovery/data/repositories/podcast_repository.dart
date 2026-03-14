import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaan/core/models/models.dart';
import 'package:kaan/services/supabase_service.dart';

final podcastRepositoryProvider = Provider<PodcastRepository>((ref) {
  return PodcastRepository(ref.watch(supabaseServiceProvider));
});

class PodcastRepository {
  final SupabaseService _supabase;

  PodcastRepository(this._supabase);

  Future<List<PodcastSearchResult>> searchPodcasts(String query) async {
    if (query.isEmpty) return [];

    try {
      return await _supabase.searchExternalPodcasts(query);
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }
}
