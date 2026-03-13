import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 130,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Library',
                        style: AppTextStyles.displaySmall.copyWith(
                          color: isDark ? Colors.white : AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your curated collection',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: isDark ? Colors.white : AppColors.secondary,
                    unselectedLabelColor: AppColors.grey500,
                    labelStyle: AppTextStyles.labelLarge,
                    unselectedLabelStyle: AppTextStyles.labelMedium,
                    tabs: const [
                      Tab(text: 'Saved'),
                      Tab(text: 'Playlists'),
                      Tab(text: 'Offline'),
                      Tab(text: 'History'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildSavedTab(),
            _buildPlaylistsTab(),
            _buildOfflineTab(),
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedTab() {
    final clips = SampleData.sampleClips;
    if (clips.isEmpty) return _buildEmptyState('No saved clips yet', 'Tap 🎧 Suno! while listening to save clips');

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      itemCount: clips.length,
      itemBuilder: (context, index) {
        final clip = clips[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: KEpisodeCard(
            title: clip.aiTitle ?? clip.episodeTitle,
            podcastName: clip.podcastName,
            duration: '${clip.durationSeconds ~/ 60}:${(clip.durationSeconds % 60).toString().padLeft(2, '0')}',
            category: 'Clip',
            onTap: () {},
            onPlay: () {},
          ),
        ).animate().fadeIn(delay: (index * 80).ms, duration: 400.ms);
      },
    );
  }

  Widget _buildPlaylistsTab() {
    final playlists = [{'name': 'Morning Commute Mix', 'count': 8}, {'name': 'Weekend Vibes', 'count': 5}, {'name': 'Tech Deep Dives', 'count': 12}];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: [
        // Create playlist button
        KCard(
          onTap: () {},
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
                ),
                child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Text(
                'Create Playlist',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 12),
        ...playlists.asMap().entries.map((entry) {
          final playlist = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: KCard(
              onTap: () {},
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${playlist['count']}',
                        style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(playlist['name'] as String, style: Theme.of(context).textTheme.titleSmall),
                        Text(
                          '${playlist['count']} episodes',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.grey500),
                ],
              ),
            ),
          ).animate().fadeIn(delay: ((entry.key + 1) * 100).ms, duration: 400.ms);
        }),
      ],
    );
  }

  Widget _buildOfflineTab() {
    return _buildEmptyState(
      'No offline content',
      'Download episodes to listen without internet',
    );
  }

  Widget _buildHistoryTab() {
    final episodes = SampleData.sampleEpisodes;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final ep = episodes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: KEpisodeCard(
            title: ep.title,
            podcastName: ep.podcastName,
            duration: ep.formattedDuration,
            category: ep.category,
            onTap: () {},
            onPlay: () {},
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.darkDivider),
            ),
            child: const Icon(Icons.library_music_rounded, color: AppColors.grey600, size: 36),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.grey400),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
