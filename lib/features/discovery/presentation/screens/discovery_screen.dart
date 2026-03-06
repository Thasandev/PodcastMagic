import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../services/supabase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../../../core/models/models.dart';
import 'dart:async';


class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isImporting = false;
  String? _importStatus;
  
  // Search state
  String _searchQuery = '';
  bool _isSearching = false;
  bool _isSyncing = false;
  List<PodcastSearchResult> _searchResults = [];
  Timer? _debounceTimer;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _youtubeController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final results = await ref.read(supabaseServiceProvider).searchExternalPodcasts(query);
      if (mounted && _searchQuery == query) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _handlePodcastTap(PodcastSearchResult podcast) async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      final episodes = await ref.read(supabaseServiceProvider).syncAndGetEpisodes(podcast.rssUrl);
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
        if (episodes.isNotEmpty) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Synced ${episodes.length} episodes for ${podcast.title}!'), backgroundColor: AppColors.success),
           );
           // After syncing, we could navigate to the player or refresh the view
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('No episodes found in feed'), backgroundColor: AppColors.error),
           );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error syncing podcast: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }


  Future<void> _handleYouTubeImport() async {
    final url = _youtubeController.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _isImporting = true;
      _importStatus = 'Connecting to YouTube...';
    });

    final yt = YoutubeExplode();
    try {
      final video = await yt.videos.get(url);
      
      setState(() {
        _importStatus = 'Extracting audio stream...';
      });

      final manifest = await yt.videos.streamsClient.getManifest(video.id);
      final audioStream = manifest.audioOnly.withHighestBitrate();
      
      if (audioStream == null) {
        throw Exception('No audio stream found for this video');
      }

      setState(() {
        _importStatus = 'Saving to Kaan library...';
      });

      await ref.read(supabaseServiceProvider).importYouTubeEpisode(
        title: video.title,
        author: video.author,
        audioUrl: audioStream.url.toString(),
        imageUrl: video.thumbnails.highResUrl,
        durationSeconds: video.duration?.inSeconds ?? 0,
        description: video.description,
      );

      _youtubeController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Successfully imported to your library!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      yt.close();
      if (mounted) {
        setState(() {
          _isImporting = false;
          _importStatus = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            title: Text('Discover', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.grey100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search podcasts, topics, creators...',
                          prefixIcon: const Icon(Icons.search, color: AppColors.grey500),
                          suffixIcon: _searchQuery.isNotEmpty 
                              ? IconButton(
                                  icon: const Icon(Icons.close, color: AppColors.grey500),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(Icons.mic, color: AppColors.primary),
                                  onPressed: () {},
                                ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onChanged: _onSearchChanged,
                      ),

                    ),
                  ),
                  if (_searchQuery.isEmpty)
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: AppColors.primary,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.grey500,
                      tabAlignment: TabAlignment.start,
                      tabs: const [
                        Tab(text: '🔥 For You'),
                        Tab(text: '📈 Trending'),
                        Tab(text: '📚 Categories'),
                        Tab(text: '🎬 YouTube Import'),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverFillRemaining(
            child: Stack(
              children: [
                _searchQuery.isNotEmpty
                    ? _buildSearchResults(context)
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildForYouTab(context),
                          _buildTrendingTab(context),
                          _buildCategoriesTab(context),
                          _buildYouTubeTab(context),
                        ],
                      ),
                if (_isSyncing)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Syncing episodes...', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchResults(BuildContext context) {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No podcasts found for "$_searchQuery"', 
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.grey500)
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: result.imageUrl != null 
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(result.imageUrl!, width: 56, height: 56, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: AppColors.grey200, child: const Icon(Icons.mic))),
                )
              : Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.grey200, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.mic)),
          title: Text(result.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(result.author, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.download_rounded, color: AppColors.primary),
          onTap: () => _handlePodcastTap(result),
        );
      },
    );
  }


  Widget _buildForYouTab(BuildContext context) {
    final episodesAsync = ref.watch(episodeFeedProvider(null));
    
    return episodesAsync.when(
      data: (episodes) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // AI recommendation banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI-Curated For You',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      Text(
                        'Based on your interests: Tech, Cricket, Business',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...episodes.map((ep) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: KEpisodeCard(
                  title: ep.title,
                  podcastName: ep.podcastName,
                  duration: ep.formattedDuration,
                  category: ep.category,
                  saveCount: ep.saveCount,
                  onTap: () => context.push('/player'),
                  onPlay: () => context.push('/player'),
                ),
              )),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildTrendingTab(BuildContext context) {
    final trendingAsync = ref.watch(trendingEpisodesProvider);

    return trendingAsync.when(
      data: (episodes) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // Trending topics
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SampleData.trendingTopics.map((topic) {
              return ActionChip(
                label: Text(topic),
                onPressed: () {},
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                labelStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('Most Saved This Week', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          ...episodes.map((ep) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: KEpisodeCard(
                  title: ep.title,
                  podcastName: ep.podcastName,
                  duration: ep.formattedDuration,
                  category: ep.category,
                  saveCount: ep.saveCount,
                  onTap: () => context.push('/player'),
                  onPlay: () => context.push('/player'),
                ),
              )),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildCategoriesTab(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: AppConstants.interestCategories.length,
      itemBuilder: (context, index) {
        final cat = AppConstants.interestCategories[index];
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(cat['color'] as int).withValues(alpha: 0.8),
                  Color(cat['color'] as int).withValues(alpha: 0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cat['icon'] as String, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    cat['name'] as String,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildYouTubeTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 60, 32, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_circle_fill, size: 64, color: AppColors.error),
            ),
            const SizedBox(height: 24),
            Text(
              'Import from YouTube',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Paste a YouTube URL to extract audio for offline commute listening',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : AppColors.grey100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _youtubeController,
                enabled: !_isImporting,
                decoration: InputDecoration(
                  hintText: 'Paste YouTube URL here...',
                  prefixIcon: const Icon(Icons.link, color: AppColors.grey500),
                  suffixIcon: _isImporting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.download, color: AppColors.primary),
                          onPressed: _handleYouTubeImport,
                        ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            if (_importStatus != null) ...[
              const SizedBox(height: 16),
              Text(
                _importStatus!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
