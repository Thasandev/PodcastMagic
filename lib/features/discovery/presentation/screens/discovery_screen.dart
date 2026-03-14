import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:audio_service/audio_service.dart' as audio_pkg;

import 'package:kaan/core/theme/app_colors.dart';
import 'package:kaan/core/theme/app_text_styles.dart';
import 'package:kaan/core/widgets/shared_widgets.dart';
import 'package:kaan/features/discovery/data/repositories/podcast_repository.dart';
import 'package:kaan/core/models/models.dart';
import 'package:kaan/services/supabase_service.dart';
import 'package:kaan/services/audio_service.dart';
import 'package:kaan/features/discovery/presentation/providers/discovery_providers.dart';
import 'package:kaan/features/home/presentation/providers/home_providers.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  bool _isSearching = false;
  bool _isLoadingResults = false;
  List<PodcastSearchResult> _searchResults = [];
  String _lastQuery = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _tabController.dispose();
    _searchController.dispose();
    _youtubeUrlController.dispose();
    super.dispose();
  }

  void _playAndNavigate(Episode episode) async {
    // 1. Tell AudioService to play this episode
    await ref.read(audioServiceProvider).playEpisode(episode);
    
    // 2. Navigate to player
    if (mounted) {
      context.push('/player', extra: episode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.darkBackground,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Discover',
                style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.darkBackground,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: KSearchInput(
                controller: _searchController,
                hintText: 'Search podcasts, creators, topics...',
                onChanged: (val) {
                  setState(() => _isSearching = val.isNotEmpty);
                  if (val.isNotEmpty) {
                    _onSearchChanged(val);
                  }
                },
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.grey500,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'For You'),
                  Tab(text: 'Trending'),
                  Tab(text: 'Categories'),
                  Tab(text: 'Import'),
                ],
              ),
            ),
          ),
        ],
        body: _isSearching
            ? _buildSearchResults()
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildForYouTab(),
                  _buildTrendingTab(),
                  _buildCategoriesTab(),
                  _buildImportTab(),
                ],
              ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    if (query == _lastQuery) return;
    _lastQuery = query;

    setState(() => _isLoadingResults = true);

    try {
      final results = await ref.read(podcastRepositoryProvider).searchPodcasts(query);
      if (mounted && query == _lastQuery) {
        setState(() {
          _searchResults = results;
          _isLoadingResults = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingResults = false);
    }
  }

  Widget _buildSearchResults() {
    if (_isLoadingResults) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 64, color: AppColors.grey700),
            const SizedBox(height: 16),
            Text(
              'No results found for "$_lastQuery"',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final podcast = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: KCard(
            onTap: () => _handlePodcastTap(podcast),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: podcast.imageUrl != null
                      ? Image.network(
                          podcast.imageUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80,
                            height: 80,
                            color: AppColors.grey800,
                            child: const Icon(Icons.podcasts_rounded, color: AppColors.grey500),
                          ),
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: AppColors.grey800,
                          child: const Icon(Icons.podcasts_rounded, color: AppColors.grey500),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        podcast.title,
                        style: AppTextStyles.headlineSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        podcast.author,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              podcast.provider.toUpperCase(),
                              style: AppTextStyles.overline.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _handlePodcastTap(podcast),
                  icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handlePodcastTap(PodcastSearchResult podcast) async {
    if (podcast.rssUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This podcast does not have a valid RSS feed.')),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final episodes = await ref.read(supabaseServiceProvider).syncAndGetEpisodes(podcast.rssUrl);
      Navigator.pop(context); // Close dialog

      if (episodes.isNotEmpty) {
        _playAndNavigate(episodes.first);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No episodes found for this podcast.')),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sync podcast: $e')),
      );
    }
  }

  Widget _buildForYouTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: KCard(
          // height removed to match KCard
          child: Center(child: Text('Personalized Pick #${index + 1}')),
        ),
      ),
    );
  }

  Widget _buildTrendingTab() {
    final episodesAsync = ref.watch(trendingEpisodesProvider);

    return episodesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (episodes) {
        if (episodes.isEmpty) {
          return const Center(child: Text('No trending episodes yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            final ep = episodes[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: KEpisodeCard(
                title: ep.title,
                podcastName: ep.podcastName,
                duration: ep.formattedDuration,
                category: ep.category,
                saveCount: ep.saveCount,
                onTap: () => _playAndNavigate(ep),
                onPlay: () => _playAndNavigate(ep),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    final categories = ['Politics', 'Technology', 'Comedy', 'Finance', 'Mythology', 'Self-Help'];
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return KCard(
          child: Center(
            child: Text(
              categories[index],
              style: AppTextStyles.headlineSmall,
            ),
          ),
        );
      },
    );
  }

  Widget _buildImportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Import from Other Platforms', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Paste a YouTube URL or RSS link to add it to your library.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 32),
          Text('YouTube Video/Playlist', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 12),
          KSearchInput(
            controller: _youtubeUrlController,
            hintText: 'https://youtube.com/watch?v=...',
          ),
          const SizedBox(height: 16),
          KGradientButton(
            text: 'Import YouTube Content',
            onPressed: () {
              // TODO: Implement YouTube import
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('YouTube import started...')),
              );
            },
          ),
          const SizedBox(height: 40),
          Text('Direct RSS Feed', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 12),
          const KSearchInput(
            hintText: 'https://example.com/feed.xml',
          ),
          const SizedBox(height: 16),
          KGradientButton(
            text: 'Sync RSS Feed',
            onPressed: () {
              // TODO: Implement RSS sync
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('RSS sync started...')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.darkBackground,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
