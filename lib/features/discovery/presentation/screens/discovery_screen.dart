import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _youtubeUrlController.dispose();
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
            expandedHeight: 170,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover',
                        style: AppTextStyles.displaySmall.copyWith(
                          color: isDark ? Colors.white : AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Find your next favourite podcast',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      KSearchInput(
                        controller: _searchController,
                        hintText: 'Search podcasts, topics, creators...',
                        onChanged: (val) =>
                            setState(() => _isSearching = val.isNotEmpty),
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
                      Tab(text: 'For You'),
                      Tab(text: 'Trending'),
                      Tab(text: 'Categories'),
                      Tab(text: 'Import'),
                    ],
                  ),
                ),
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

  Widget _buildSearchResults() {
    final query = _searchController.text.toLowerCase();
    final results = SampleData.sampleEpisodes.where((ep) {
      return ep.title.toLowerCase().contains(query) ||
          ep.podcastName.toLowerCase().contains(query);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: AppColors.grey600),
            const SizedBox(height: 16),
            Text(
              'No results found for "$query"',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final ep = results[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: KEpisodeCard(
            title: ep.title,
            podcastName: ep.podcastName,
            duration: ep.formattedDuration,
            category: ep.category,
            saveCount: ep.saveCount,
            onTap: () {},
            onPlay: () {},
          ),
        ).animate().fadeIn(delay: (index * 50).ms, duration: 300.ms);
      },
    );
  }

  Widget _buildForYouTab() {
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
            saveCount: ep.saveCount,
            onTap: () {},
            onPlay: () {},
          ),
        ).animate().fadeIn(delay: (index * 80).ms, duration: 400.ms);
      },
    );
  }

  Widget _buildTrendingTab() {
    final episodes = SampleData.sampleEpisodes;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: [
        // Featured trending
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2230), Color(0xFF252A40)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.darkDivider.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '🔥 HOT',
                      style: AppTextStyles.overline.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text('Updated hourly', style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                episodes.first.title,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                episodes.first.podcastName,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 16),
        ...episodes.asMap().entries.map((entry) {
          final ep = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: KEpisodeCard(
              title: ep.title,
              podcastName: ep.podcastName,
              duration: ep.formattedDuration,
              category: ep.category,
              saveCount: ep.saveCount,
              onTap: () {},
              onPlay: () {},
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoriesTab() {
    final categories = [
      {'icon': '💻', 'name': 'Technology', 'color': 0xFF60A5FA},
      {'icon': '💰', 'name': 'Business', 'color': 0xFFF5A623},
      {'icon': '🧘', 'name': 'Mindfulness', 'color': 0xFF7ECFB3},
      {'icon': '🎭', 'name': 'Entertainment', 'color': 0xFFFF6161},
      {'icon': '📚', 'name': 'Education', 'color': 0xFFA78BFA},
      {'icon': '🏏', 'name': 'Sports', 'color': 0xFF34D399},
      {'icon': '🗞️', 'name': 'News', 'color': 0xFF60A5FA},
      {'icon': '🎵', 'name': 'Music', 'color': 0xFFF472B6},
    ];

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final color = Color(cat['color'] as int);
        return KCard(
              onTap: () {},
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cat['icon'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat['name'] as String,
                        style: AppTextStyles.labelLarge.copyWith(color: color),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 28,
                        height: 3,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: (index * 60).ms, duration: 400.ms)
            .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
      },
    );
  }

  Widget _buildImportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // YouTube Import
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E2230), Color(0xFF252A40)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.darkDivider.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.play_circle_filled,
                        color: AppColors.error,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YouTube Import',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Convert any video to audio',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.darkDivider),
                  ),
                  child: TextField(
                    controller: _youtubeUrlController,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Paste YouTube URL...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey600,
                      ),
                      prefixIcon: const Icon(
                        Icons.link_rounded,
                        color: AppColors.grey500,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                KGradientButton(
                  text: 'Import Audio',
                  icon: Icons.download_rounded,
                  height: 48,
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // RSS Import
          Text('Other Sources', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          _ImportOption(
            icon: Icons.rss_feed_rounded,
            label: 'RSS Feed',
            desc: 'Import from any RSS URL',
            color: AppColors.accent,
          ),
          _ImportOption(
            icon: Icons.podcasts_rounded,
            label: 'Apple Podcasts',
            desc: 'Import your subscriptions',
            color: AppColors.jade,
          ),
          _ImportOption(
            icon: Icons.music_note_rounded,
            label: 'Spotify',
            desc: 'Import your liked shows',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _ImportOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final Color color;

  const _ImportOption({
    required this.icon,
    required this.label,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: KCard(
        onTap: () {},
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.titleSmall),
                  Text(desc, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.grey500),
          ],
        ),
      ),
    );
  }
}
