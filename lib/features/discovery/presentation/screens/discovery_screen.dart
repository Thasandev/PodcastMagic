import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../core/constants/app_constants.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> with SingleTickerProviderStateMixin {
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
                        decoration: InputDecoration(
                          hintText: 'Search podcasts, topics, creators...',
                          prefixIcon: const Icon(Icons.search, color: AppColors.grey500),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.mic, color: AppColors.primary),
                            onPressed: () {},
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onChanged: (val) {},
                      ),
                    ),
                  ),
                  // Tabs
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildForYouTab(context),
                _buildTrendingTab(context),
                _buildCategoriesTab(context),
                _buildYouTubeTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForYouTab(BuildContext context) {
    final episodes = SampleData.sampleEpisodes;
    return ListView(
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
    );
  }

  Widget _buildTrendingTab(BuildContext context) {
    return ListView(
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
        ...(SampleData.sampleEpisodes.toList()
            ..sort((a, b) => b.saveCount.compareTo(a.saveCount)))
            .take(5).map((ep) => Padding(
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
                decoration: InputDecoration(
                  hintText: 'Paste YouTube URL here...',
                  prefixIcon: const Icon(Icons.link, color: AppColors.grey500),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.download, color: AppColors.primary),
                    onPressed: () {},
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
