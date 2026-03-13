import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final episodes = SampleData.sampleEpisodes;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
                        'Community',
                        style: AppTextStyles.displaySmall.copyWith(
                          color: isDark ? Colors.white : AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Learn together, grow together',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Community Stats ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatChip(label: 'Listeners', value: '12.4K', gradient: AppColors.primaryGradient),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatChip(label: 'Reflections', value: '3.2K', gradient: AppColors.goldGradient),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatChip(label: 'Cities', value: '85', gradient: AppColors.jadeGradient),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms),
          ),

          // ── Trending by City ──
          SliverToBoxAdapter(
            child: KSectionHeader(title: '🏙️ Trending by City', actionText: 'View all'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _CityCard(city: 'Mumbai', listeners: '3.2K', emoji: '🏙️'),
                  _CityCard(city: 'Delhi', listeners: '2.8K', emoji: '🕌'),
                  _CityCard(city: 'Bangalore', listeners: '2.1K', emoji: '💻'),
                  _CityCard(city: 'Chennai', listeners: '1.5K', emoji: '🛕'),
                  _CityCard(city: 'Pune', listeners: '1.2K', emoji: '🏞️'),
                ],
              ),
            ),
          ),

          // ── Popular Saves ──
          SliverToBoxAdapter(
            child: KSectionHeader(title: '🔥 Popular Saves'),
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

          // ── Friend Activity ──
          SliverToBoxAdapter(
            child: KSectionHeader(title: '🧑‍🤝‍🧑 Friend Activity'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _FriendActivity(name: 'Arjun Singh', action: 'saved a clip from', episode: 'AI Revolution in India', time: '2h ago'),
                  _FriendActivity(name: 'Priya Sharma', action: 'shared a reflection on', episode: 'Startup Life', time: '3h ago'),
                  _FriendActivity(name: 'Rahul Kumar', action: 'is listening to', episode: 'Mindfulness for Coders', time: 'Now'),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Gradient gradient;

  const _StatChip({required this.label, required this.value, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final String city;
  final String listeners;
  final String emoji;

  const _CityCard({required this.city, required this.listeners, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      child: KCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(city, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            Text('$listeners 🎧', style: TextStyle(fontSize: 10, color: AppColors.grey500)),
          ],
        ),
      ),
    );
  }
}

class _FriendActivity extends StatelessWidget {
  final String name;
  final String action;
  final String episode;
  final String time;

  const _FriendActivity({required this.name, required this.action, required this.episode, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: KCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Center(
                child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: ' $action '),
                    TextSpan(text: episode, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
            Text(time, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
