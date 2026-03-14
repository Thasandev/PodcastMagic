import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SampleData.sampleUser;
    final badges = SampleData.sampleBadges;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            actions: [
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.grey400,
                ),
              ),
              IconButton(
                onPressed: () => context.push('/coins'),
                icon: const Icon(
                  Icons.monetization_on_outlined,
                  color: AppColors.accent,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A1530), Color(0xFF0F1117)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 36),
                      // Avatar with gradient ring
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1A1530),
                          ),
                          child: Center(
                            child: Text(
                              user.name[0],
                              style: AppTextStyles.displayMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ).animate().scale(
                        begin: const Offset(0.8, 0.8),
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user.name,
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.bio ?? '',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      // Rank badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.25),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Text(
                          '⚔️ ${user.pahalwanRank}',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Stats ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _ProfileStat(
                      label: 'Listening',
                      value:
                          '${(user.totalListeningMinutes / 60).toStringAsFixed(0)}h',
                      icon: Icons.headphones_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ProfileStat(
                      label: 'Streak',
                      value: '${user.currentStreak} 🔥',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ProfileStat(
                      label: 'Coins',
                      value: '${user.kaanCoins}',
                      icon: Icons.monetization_on_rounded,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ProfileStat(
                      label: 'Score',
                      value: '${user.streetCredScore}',
                      icon: Icons.stars_rounded,
                      color: AppColors.jade,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
          ),

          // ── Streak section ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: KCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.currentStreak} Day Streak',
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.secondary,
                              ),
                            ),
                            Text(
                              'Longest: ${user.longestStreak} days',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.shield_rounded, size: 16),
                          label: const Text(
                            'Insure',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.jade,
                            side: const BorderSide(color: AppColors.jade),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Week view
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun',
                          ].asMap().entries.map((e) {
                            final isCompleted = e.key < 5;
                            final isToday = e.key == 4;
                            return Column(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: isCompleted
                                        ? AppColors.primaryGradient
                                        : null,
                                    color: isCompleted
                                        ? null
                                        : AppColors.darkCard,
                                    shape: BoxShape.circle,
                                    border: isToday
                                        ? Border.all(
                                            color: AppColors.accent,
                                            width: 2,
                                          )
                                        : null,
                                    boxShadow: isCompleted
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.2),
                                              blurRadius: 8,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Icon(
                                    isCompleted
                                        ? Icons.check_rounded
                                        : Icons.circle,
                                    color: isCompleted
                                        ? Colors.white
                                        : AppColors.grey700,
                                    size: isCompleted ? 20 : 8,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  e.value,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isToday
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: isToday
                                        ? AppColors.accent
                                        : AppColors.grey500,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Badges ──
          SliverToBoxAdapter(
            child: Column(
              children: [
                KSectionHeader(title: 'Badges', actionText: 'View all'),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: badges.length,
                    itemBuilder: (context, index) {
                      final badge = badges[index];
                      return Container(
                        width: 85,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: badge.isUnlocked
                                    ? AppColors.primary.withValues(alpha: 0.12)
                                    : AppColors.darkCard,
                                shape: BoxShape.circle,
                                border: badge.isUnlocked
                                    ? Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      )
                                    : null,
                                boxShadow: badge.isUnlocked
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.15,
                                          ),
                                          blurRadius: 10,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  badge.icon,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: badge.isUnlocked
                                        ? null
                                        : AppColors.grey600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              badge.name,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: badge.isUnlocked
                                    ? null
                                    : AppColors.grey600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ).animate().fadeIn(
                        delay: (index * 80).ms,
                        duration: 400.ms,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Quick actions ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _QuickAction(
                    icon: Icons.mic_rounded,
                    label: 'My Reflections',
                    subtitle: '12 reflections',
                    onTap: () => context.push('/reflections'),
                  ),
                  _QuickAction(
                    icon: Icons.people_rounded,
                    label: 'Friends',
                    subtitle: '24 friends on Kaan',
                    onTap: () {},
                  ),
                  _QuickAction(
                    icon: Icons.card_giftcard_rounded,
                    label: 'Refer & Earn',
                    subtitle: 'Get 100 coins per referral',
                    onTap: () {},
                  ),
                  _QuickAction(
                    icon: Icons.download_rounded,
                    label: 'Export Notes',
                    subtitle: 'Notion, Readwise, Obsidian',
                    onTap: () {},
                  ),
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

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ProfileStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return KCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 10, color: AppColors.grey500)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: AppColors.grey500),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.grey600,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}
