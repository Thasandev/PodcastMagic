
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SampleData.sampleUser;
    final episodes = SampleData.sampleEpisodes;
    final reflections = SampleData.sampleReflections;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── APP BAR ──
          SliverAppBar(
            floating: true,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            toolbarHeight: 68,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                ),
                Row(
                  children: [
                    Text(
                      user.name.split(' ').first,
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: isDark ? Colors.white : AppColors.secondary,
                      ),
                    ),
                    Text(
                      ' 👋',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => context.push('/coins'),
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        '${user.kaanCoins}',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),

          // ── HERO: Start Commute ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: _buildCommuteHero(context),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
          ),

          // ── QUICK STATS ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: KStatCard(
                      label: 'Streak',
                      value: '${user.currentStreak} 🔥',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KStatCard(
                      label: 'Rank',
                      value: user.pahalwanRank,
                      icon: Icons.shield_rounded,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KStatCard(
                      label: 'Cred',
                      value: '${user.streetCredScore}',
                      icon: Icons.stars_rounded,
                      color: AppColors.jade,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
          ),

          // ── TRENDING ──
          SliverToBoxAdapter(
            child: KSectionHeader(
              title: 'Trending Now',
              actionText: 'See all',
              onAction: () => context.go('/discover'),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: episodes.length,
                itemBuilder: (context, index) {
                  final ep = episodes[index];
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 12),
                    child: KCard(
                      onTap: () => context.push('/player'),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.headphones_rounded, color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ep.category,
                                      style: AppTextStyles.overline.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      ep.podcastName,
                                      style: AppTextStyles.caption,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            ep.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 12, color: AppColors.grey500),
                              const SizedBox(width: 4),
                              Text(ep.formattedDuration, style: AppTextStyles.caption),
                              const Spacer(),
                              Icon(Icons.bookmark_rounded, size: 12, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text('${ep.saveCount}', style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (300 + index * 100).ms, duration: 400.ms);
                },
              ),
            ),
          ),

          // ── TODAY'S MIX ──
          SliverToBoxAdapter(
            child: KSectionHeader(title: 'Today\'s Mix', actionText: 'Refresh'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: episodes.take(3).map((ep) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
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
                }).toList(),
              ),
            ),
          ),

          // ── CHAI PE CHARCHA ──
          SliverToBoxAdapter(
            child: KSectionHeader(
              title: '☕ Chai Pe Charcha',
              actionText: 'View all',
              onAction: () => context.push('/reflections'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: reflections.take(2).map((ref) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: KCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                                child: Text(
                                  ref.userName[0],
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ref.userName, style: Theme.of(context).textTheme.titleSmall),
                                    Text(
                                      '📍${ref.city}',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                              if (ref.audioUrl != null)
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 16),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ref.transcript,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }

  Widget _buildCommuteHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E2230), Color(0xFF252A40)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.darkDivider.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready for\nyour commute?',
                  style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  '30 min curated session waiting',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey400),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'Start',
                        style: AppTextStyles.button.copyWith(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Vinyl disc motif
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 1),
                  ),
                ),
                const Icon(Icons.headphones_rounded, color: Colors.white, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
