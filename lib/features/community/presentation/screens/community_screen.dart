import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌍 Sabka Kaan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Community highlights header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E4057), Color(0xFF4A5E78)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Community Highlights',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  'Most-saved moments from across India',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _CommunityStatChip(label: '12.5K', subtitle: 'Active today'),
                    const SizedBox(width: 12),
                    _CommunityStatChip(label: '3.2K', subtitle: 'Clips saved'),
                    const SizedBox(width: 12),
                    _CommunityStatChip(label: '890', subtitle: 'Reflections'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Trending in cities
          Text('🏙️ What Cities Are Learning', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          ...SampleData.cityTrending.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: KCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Text('📍', style: TextStyle(fontSize: 20))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['city'] as String, style: Theme.of(context).textTheme.titleSmall),
                            Text(
                              item['topic'] as String,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${item['listeners']}',
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.accent),
                          ),
                          Text(
                            'listening',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),

          const SizedBox(height: 20),

          // Popular saves
          Text('🔥 Most Saved Moments', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          ...SampleData.sampleEpisodes.take(3).map((ep) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: KCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.headphones, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ep.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text(ep.podcastName, style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.bookmark, size: 14, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text('${ep.saveCount} people saved this', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Text(ep.formattedDuration, style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    ],
                  ),
                ),
              )),

          const SizedBox(height: 20),

          // Friend activity
          Text('👥 Friend Activity', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          _FriendActivity(name: 'Priya', action: 'saved a clip from', target: 'Tech Talks India', time: '2h ago'),
          _FriendActivity(name: 'Arjun', action: 'started a streak of', target: '15 days 🔥', time: '5h ago'),
          _FriendActivity(name: 'Neha', action: 'shared a reflection about', target: 'Morning Habits', time: '8h ago'),
          _FriendActivity(name: 'Karthik', action: 'reached rank', target: 'Ustaad ⚔️', time: '1d ago'),

          const SizedBox(height: 140),
        ],
      ),
    );
  }
}

class _CommunityStatChip extends StatelessWidget {
  final String label;
  final String subtitle;

  const _CommunityStatChip({required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
            Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _FriendActivity extends StatelessWidget {
  final String name;
  final String action;
  final String target;
  final String time;

  const _FriendActivity({required this.name, required this.action, required this.target, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: KCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: ' $action '),
                    TextSpan(text: target, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            Text(time, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
