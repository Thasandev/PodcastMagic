import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaan/core/models/models.dart';

final StateProvider<List<PodcastSearchResult>> searchResultsProvider = StateProvider<List<PodcastSearchResult>>((ref) => []);
final StateProvider<bool> isSearchingProvider = StateProvider<bool>((ref) => false);
final StateProvider<bool> isLoadingResultsProvider = StateProvider<bool>((ref) => false);
