import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
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
            expandedHeight: 280,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            actions: [
              IconButton(onPressed: () => context.push('/settings'), icon: const Icon(Icons.settings_outlined)),
              IconButton(onPressed: () => context.push('/coins'), icon: const Icon(Icons.monetization_on_outlined)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E4057), Color(0xFF1A2A3D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      // Avatar
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            user.name[0],
                            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.bio ?? '',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // Rank badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '⚔️ ${user.pahalwanRank}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Stats row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _ProfileStat(
                      label: 'Listening',
                      value: '${(user.totalListeningMinutes / 60).toStringAsFixed(0)}h',
                      icon: Icons.headphones,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ProfileStat(
                      label: 'Streak',
                      value: '${user.currentStreak} 🔥',
                      icon: Icons.local_fire_department,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ProfileStat(
                      label: 'Coins',
                      value: '${user.kaanCoins}',
                      icon: Icons.monetization_on,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ProfileStat(
                      label: 'Score',
                      value: '${user.streetCredScore}',
                      icon: Icons.stars,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Streak section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: KCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('🔥', style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.currentStreak} Day Streak',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              'Longest: ${user.longestStreak} days',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.shield, size: 16),
                          label: const Text('Insure', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accent,
                            side: const BorderSide(color: AppColors.accent),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Week view
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].asMap().entries.map((e) {
                        final isCompleted = e.key < 5;
                        final isToday = e.key == 4;
                        return Column(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? AppColors.primary
                                    : (isDark ? AppColors.darkCard : AppColors.grey100),
                                shape: BoxShape.circle,
                                border: isToday ? Border.all(color: AppColors.gold, width: 2) : null,
                              ),
                              child: Icon(
                                isCompleted ? Icons.check : Icons.circle,
                                color: isCompleted ? Colors.white : AppColors.grey400,
                                size: isCompleted ? 20 : 8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              e.value,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                                color: isToday ? AppColors.primary : AppColors.grey500,
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

          // Badges
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
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : (isDark ? AppColors.darkCard : AppColors.grey100),
                                shape: BoxShape.circle,
                                border: badge.isUnlocked
                                    ? Border.all(color: AppColors.primary, width: 2)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  badge.icon,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: badge.isUnlocked ? null : AppColors.grey400,
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
                                color: badge.isUnlocked ? null : AppColors.grey500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Quick actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _QuickAction(icon: Icons.mic, label: 'My Reflections', subtitle: '12 reflections', onTap: () => context.push('/reflections')),
                  _QuickAction(icon: Icons.people, label: 'Friends', subtitle: '24 friends on Kaan', onTap: () {}),
                  _QuickAction(icon: Icons.card_giftcard, label: 'Refer & Earn', subtitle: 'Get 100 coins per referral', onTap: () {}),
                  _QuickAction(icon: Icons.download, label: 'Export Notes', subtitle: 'Notion, Readwise, Obsidian', onTap: () {}),
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

  const _ProfileStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return KCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: color)),
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

  const _QuickAction({required this.icon, required this.label, required this.subtitle, required this.onTap});

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
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.grey500)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey400),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}
