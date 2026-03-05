import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../services/supabase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = SampleData.sampleUser;
    final episodesAsync = ref.watch(episodeFeedProvider(null));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.headphones, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  'Kaan',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => context.push('/coins'),
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        '${user.kaanCoins}',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.notifications_outlined),
              ),
            ],
          ),

          // Greeting + Start Commute
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.grey400 : AppColors.grey600,
                        ),
                  ),
                  Text(
                    user.name.split(' ')[0],
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 20),

                  // Start Commute Mode button
                  InkWell(
                    onTap: () => context.push('/player'),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFFF8F66), Color(0xFFFFAA85)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.play_circle_filled, color: Colors.white, size: 48),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Start Commute Mode',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${user.commuteDurationMin} min mix ready • ${episodes.length} clips',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Quick preview chips
                          Wrap(
                            spacing: 8,
                            children: ['🎯 AI Curated', '🏏 Cricket', '💻 Tech', '😂 Comedy']
                                .map((tag) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        tag,
                                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: KStatCard(
                      label: 'Day Streak',
                      value: '${user.currentStreak} 🔥',
                      icon: Icons.local_fire_department,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KStatCard(
                      label: 'Rank',
                      value: user.pahalwanRank,
                      icon: Icons.emoji_events,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KStatCard(
                      label: 'Street Cred',
                      value: '${user.streetCredScore}',
                      icon: Icons.stars,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Trending in Your City
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                KSectionHeader(
                  title: 'Trending in Mumbai 🏙️',
                  actionText: 'See all',
                  onAction: () => context.push('/community'),
                ),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: SampleData.cityTrending.length,
                    itemBuilder: (context, index) {
                      final item = SampleData.cityTrending[index];
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: KCard(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '📍 ${item['city']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.grey400 : AppColors.grey600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['topic'] as String,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                '${item['listeners']} listening',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: KSectionHeader(
              title: 'Today\'s Mix 🎧',
              actionText: 'View all',
              onAction: () {},
            ),
          ),
          episodesAsync.when(
            data: (episodes) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ep = episodes[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: KEpisodeCard(
                      title: ep.title,
                      podcastName: ep.podcastName,
                      duration: ep.formattedDuration,
                      category: ep.category,
                      saveCount: ep.saveCount,
                      onTap: () => context.push('/player'),
                      onPlay: () => context.push('/player'),
                    ),
                  );
                },
                childCount: episodes.length,
              ),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverToBoxAdapter(
              child: Center(child: Text('Error loading feed: $err')),
            ),
          ),

          // Chai Pe Charcha section
          SliverToBoxAdapter(
            child: Column(
              children: [
                KSectionHeader(
                  title: 'Chai Pe Charcha ☕',
                  actionText: 'Record yours',
                  onAction: () => context.push('/record-reflection'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: SampleData.sampleReflections.take(3).map((ref) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: KCard(
                          onTap: () => context.push('/reflections'),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                                    child: Text(
                                      ref.userName[0],
                                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ref.userName,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        Text(
                                          '${ref.city} • ${_timeAgo(ref.createdAt)}',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.arrow_upward, size: 14, color: AppColors.accent),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${ref.upvotes}',
                                          style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                ref.transcript,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (ref.episodeTitle != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '🎧 ${ref.episodeTitle}',
                                    style: TextStyle(fontSize: 11, color: AppColors.primary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  static String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
