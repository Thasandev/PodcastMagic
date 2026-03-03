import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
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
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            title: Text('Library', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.grey500,
              tabs: const [
                Tab(text: '📌 Saves'),
                Tab(text: '📂 Playlists'),
                Tab(text: '⬇️ Offline'),
                Tab(text: '🕐 History'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildSavesTab(),
            _buildPlaylistsTab(),
            _buildOfflineTab(),
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSavesTab() {
    final clips = SampleData.sampleClips;
    if (clips.isEmpty) {
      return _buildEmptyState(
        icon: Icons.bookmark_outline,
        title: 'No saved clips yet',
        subtitle: 'Triple-tap your headphones or say "Suno" while listening to save moments',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clips.length,
      itemBuilder: (context, index) {
        final clip = clips[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: KCard(
            onTap: () => context.push('/player'),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bookmark, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clip.aiTitle ?? 'Saved clip',
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        clip.podcastName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      if (clip.aiSummary != null)
                        Text(
                          clip.aiSummary!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 12, color: AppColors.grey500),
                          const SizedBox(width: 3),
                          Text('${clip.durationSeconds}s', style: Theme.of(context).textTheme.labelSmall),
                          const SizedBox(width: 12),
                          Icon(Icons.schedule, size: 12, color: AppColors.grey500),
                          const SizedBox(width: 3),
                          Text(_timeAgo(clip.savedAt), style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'remix', child: Text('🎤 Remix')),
                    const PopupMenuItem(value: 'share', child: Text('📤 Share')),
                    const PopupMenuItem(value: 'delete', child: Text('🗑️ Delete')),
                  ],
                  onSelected: (val) {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Create playlist button
        KCard(
          onTap: () {},
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create New Playlist', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary)),
                  Text('Or collaborative playlist with friends', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Sample playlists
        _PlaylistCard(
          name: 'Morning Motivation',
          episodeCount: 12,
          icon: '🌅',
          isCollaborative: false,
        ),
        const SizedBox(height: 8),
        _PlaylistCard(
          name: 'Tech Deep Dives',
          episodeCount: 8,
          icon: '💻',
          isCollaborative: false,
        ),
        const SizedBox(height: 8),
        _PlaylistCard(
          name: 'Team Commute Mix',
          episodeCount: 15,
          icon: '👥',
          isCollaborative: true,
        ),
      ],
    );
  }

  Widget _buildOfflineTab() {
    return _buildEmptyState(
      icon: Icons.download_done,
      title: 'Offline content',
      subtitle: 'Downloaded episodes will appear here for commute listening without internet',
    );
  }

  Widget _buildHistoryTab() {
    final episodes = SampleData.sampleEpisodes.take(5).toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final ep = episodes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: KEpisodeCard(
            title: ep.title,
            podcastName: ep.podcastName,
            duration: ep.formattedDuration,
            category: ep.category,
            onTap: () => context.push('/player'),
            onPlay: () => context.push('/player'),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.grey400),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey500)),
          ],
        ),
      ),
    );
  }

  static String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _PlaylistCard extends StatelessWidget {
  final String name;
  final int episodeCount;
  final String icon;
  final bool isCollaborative;

  const _PlaylistCard({
    required this.name,
    required this.episodeCount,
    required this.icon,
    required this.isCollaborative,
  });

  @override
  Widget build(BuildContext context) {
    return KCard(
      onTap: () {},
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleSmall),
                    if (isCollaborative) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Collab', style: TextStyle(fontSize: 9, color: AppColors.accent, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ],
                ),
                Text('$episodeCount episodes', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 36),
        ],
      ),
    );
  }
}
