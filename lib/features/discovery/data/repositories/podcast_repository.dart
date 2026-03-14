import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/models.dart';

final podcastRepositoryProvider = Provider<PodcastRepository>((ref) {
  return PodcastRepository(Dio());
});

class PodcastRepository {
  final Dio _dio;

  PodcastRepository(this._dio);

  Future<List<PodcastSearchResult>> searchPodcasts(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await _dio.get(
        'https://itunes.apple.com/search',
        queryParameters: {
          'media': 'podcast',
          'term': query,
          'limit': 20,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] ?? [];
        return results.map((json) {
          return PodcastSearchResult(
            title: json['collectionName'] ?? 'Unknown Podcast',
            author: json['artistName'] ?? 'Unknown Author',
            imageUrl: json['artworkUrl600'] ?? json['artworkUrl100'],
            rssUrl: json['feedUrl'] ?? '',
            provider: 'itunes',
          );
        }).toList();
      }
      return [];
    } catch (e) {
      // Log error or handle as needed
      return [];
    }
  }
}
