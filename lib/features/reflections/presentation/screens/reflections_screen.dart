import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class ReflectionsScreen extends StatelessWidget {
  const ReflectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reflections = SampleData.sampleReflections;
    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Chai Pe Charcha'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, size: 18),
            label: const Text('Filter'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          // Community Wisdom Feed header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.public, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Community Wisdom Feed',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      Text(
                        'See what India is learning today',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Trending topics
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Mumbai 🏙️', 'Delhi 🏛️', 'Bangalore 💻', 'All India 🇮🇳'].map((city) {
              return FilterChip(
                label: Text(city),
                onSelected: (_) {},
                selected: city.startsWith('All'),
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Reflections
          ...reflections.map((ref) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: KCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                            child: Text(
                              ref.userName[0],
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ref.userName, style: Theme.of(context).textTheme.titleSmall),
                                Text(
                                  '📍${ref.city} • ${_timeAgo(ref.createdAt)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          if (ref.audioUrl != null)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow, color: AppColors.primary, size: 20),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        ref.transcript,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                      if (ref.episodeTitle != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.headphones, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  ref.episodeTitle!,
                                  style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      // Action bar
                      Row(
                        children: [
                          _ReflectionAction(icon: Icons.arrow_upward, label: '${ref.upvotes}', color: AppColors.accent),
                          const SizedBox(width: 16),
                          _ReflectionAction(icon: Icons.chat_bubble_outline, label: '${ref.reactionCount}', color: AppColors.grey500),
                          const SizedBox(width: 16),
                          _ReflectionAction(icon: Icons.share_outlined, label: 'Share', color: AppColors.grey500),
                          const SizedBox(width: 16),
                          _ReflectionAction(icon: Icons.mic_outlined, label: 'React', color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.mic, color: Colors.white),
        label: const Text('Record Reflection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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

class _ReflectionAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ReflectionAction({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
