import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class DangalScreen extends StatefulWidget {
  const DangalScreen({super.key});

  @override
  State<DangalScreen> createState() => _DangalScreenState();
}

class _DangalScreenState extends State<DangalScreen>
    with SingleTickerProviderStateMixin {
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
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 240,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Trophy with glow
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.goldGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.3),
                                blurRadius: 24,
                              ),
                            ],
                          ),
                          child: const Center(child: Text('🏆', style: TextStyle(fontSize: 28))),
                        ).animate().scale(begin: const Offset(0.6, 0.6), duration: 600.ms, curve: Curves.elasticOut),
                        const SizedBox(height: 12),
                        Text(
                          'Dangal',
                          style: AppTextStyles.displaySmall.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Weekly Listening Wars',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                        ),
                      ],
                    ),
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
                    indicatorColor: AppColors.accent,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: isDark ? Colors.white : AppColors.secondary,
                    unselectedLabelColor: AppColors.grey500,
                    labelStyle: AppTextStyles.labelLarge,
                    tabs: const [
                      Tab(text: '🏙️ City'),
                      Tab(text: '🏢 Office'),
                      Tab(text: '👨‍👩‍👦 Family'),
                      Tab(text: '🌍 Overall'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildLeaderboard('Mumbai'),
            _buildLeaderboard('Office'),
            _buildLeaderboard('Family'),
            _buildLeaderboard('Overall'),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard(String type) {
    final entries = SampleData.sampleLeaderboard;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // Top 3 podium
                if (entries.length >= 3)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: _PodiumCard(entry: entries[1], medal: '🥈', height: 120)),
                        const SizedBox(width: 8),
                        Expanded(child: _PodiumCard(entry: entries[0], medal: '🥇', height: 150)),
                        const SizedBox(width: 8),
                        Expanded(child: _PodiumCard(entry: entries[2], medal: '🥉', height: 100)),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms),

                // Current user highlight
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text('👤', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Rank: #4',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                            Text(
                              '${SampleData.sampleUser.pahalwanRank} • ${SampleData.sampleUser.totalListeningMinutes} min this week',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text('Street Cred', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text(
                            '${SampleData.sampleUser.streetCredScore}',
                            style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                // Remaining entries
                ...entries.skip(3).toList().asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _LeaderboardRow(entry: e.value),
                    ).animate().fadeIn(delay: (300 + e.key * 80).ms, duration: 400.ms)),

                // Challenge button
                const SizedBox(height: 16),
                KGradientButton(
                  text: '⚔️ Challenge a Friend',
                  gradient: AppColors.accentGradient,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final dynamic entry;
  final String medal;
  final double height;

  const _PodiumCard({required this.entry, required this.medal, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(medal, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12),
            ],
          ),
          child: Center(
            child: Text(
              entry.userName[0],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          entry.userName.split(' ')[0],
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          entry.formattedListening,
          style: TextStyle(color: AppColors.grey500, fontSize: 11),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withValues(alpha: 0.25), AppColors.primary.withValues(alpha: 0.05)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
          child: Center(
            child: Text(
              entry.pahalwanRank,
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final dynamic entry;
  const _LeaderboardRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return KCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: entry.isCurrentUser ? AppColors.primary : AppColors.grey500,
              ),
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: entry.isCurrentUser
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.darkCard,
            child: Text(
              entry.userName[0],
              style: TextStyle(
                color: entry.isCurrentUser ? AppColors.primary : AppColors.grey400,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.userName,
                  style: TextStyle(
                    fontWeight: entry.isCurrentUser ? FontWeight.w700 : FontWeight.w500,
                    color: entry.isCurrentUser ? AppColors.primary : null,
                  ),
                ),
                Text(entry.pahalwanRank, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.formattedListening,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              Text(
                'Score: ${entry.streetCredScore}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
