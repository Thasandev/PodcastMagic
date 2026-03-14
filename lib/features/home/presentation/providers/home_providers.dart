import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaan/services/supabase_service.dart';
import 'package:kaan/core/models/models.dart';

final trendingEpisodesProvider = FutureProvider<List<Episode>>((ref) async {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return supabaseService.getTrending(limit: 10);
});

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final supabaseService = ref.watch(supabaseServiceProvider);
  try {
    final profile = await supabaseService.getProfile();
    return profile;
  } catch (e) {
    return null;
  }
});

final feedEpisodesProvider = FutureProvider<List<Episode>>((ref) async {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return supabaseService.getFeed(limit: 20);
});
