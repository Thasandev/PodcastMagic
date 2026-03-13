import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class ReflectionsScreen extends StatelessWidget {
  const ReflectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reflections = SampleData.sampleReflections;
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
                        '✍️ Reflections',
                        style: AppTextStyles.displaySmall.copyWith(
                          color: isDark ? Colors.white : AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Community wisdom, shared aloud',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Trending City ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['📍 Mumbai', '📍 Delhi', '📍 Bangalore', '📍 Chennai'].map((city) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.darkDivider),
                    ),
                    child: Text(
                      city,
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.grey300),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Reflections Feed ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final ref = reflections[index % reflections.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: KCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.primaryGradient,
                              ),
                              child: Center(
                                child: Text(
                                  ref.userName[0],
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ref.userName, style: Theme.of(context).textTheme.titleSmall),
                                  Text(
                                    '📍 ${ref.city} • ${_timeAgo(ref.createdAt)}',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            if (ref.audioUrl != null)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 20),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          ref.transcript,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                        ),
                        const SizedBox(height: 14),
                        // Action bar
                        Row(
                          children: [
                            _ReflectionAction(icon: Icons.arrow_upward_rounded, label: '${ref.upvotes}', color: AppColors.primary),
                            const SizedBox(width: 16),
                            _ReflectionAction(icon: Icons.chat_bubble_outline_rounded, label: '${ref.reactionCount}', color: AppColors.grey500),
                            const SizedBox(width: 16),
                            _ReflectionAction(icon: Icons.share_outlined, label: '', color: AppColors.grey500),
                            const Spacer(),
                            Text('🔥 ${ref.reactionCount}', style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (index * 80).ms, duration: 400.ms);
              },
              childCount: reflections.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/recordReflection'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.mic_rounded, color: Colors.white),
        label: const Text('Record', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ],
    );
  }
}
