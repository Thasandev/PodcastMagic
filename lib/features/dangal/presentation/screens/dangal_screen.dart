import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class DangalScreen extends StatefulWidget {
  const DangalScreen({super.key});

  @override
  State<DangalScreen> createState() => _DangalScreenState();
}

class _DangalScreenState extends State<DangalScreen> with SingleTickerProviderStateMixin {
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
            expandedHeight: 200,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF3D00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Text('🏆', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 8),
                        const Text(
                          'Dangal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Weekly Listening Wars',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
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
                    indicatorColor: AppColors.primary,
                    labelColor: isDark ? Colors.white : AppColors.secondary,
                    unselectedLabelColor: AppColors.grey500,
                    indicatorWeight: 3,
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
      padding: const EdgeInsets.all(16),
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
                        // 2nd place
                        Expanded(child: _PodiumCard(entry: entries[1], medal: '🥈', height: 120)),
                        const SizedBox(width: 8),
                        // 1st place
                        Expanded(child: _PodiumCard(entry: entries[0], medal: '🥇', height: 150)),
                        const SizedBox(width: 8),
                        // 3rd place
                        Expanded(child: _PodiumCard(entry: entries[2], medal: '🥉', height: 100)),
                      ],
                    ),
                  ),

                // Current user highlight
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
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
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Text('Street Cred', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text(
                            '${SampleData.sampleUser.streetCredScore}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Remaining entries
                ...entries.skip(3).map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _LeaderboardRow(entry: entry),
                    )),

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
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
          child: Text(
            entry.userName[0],
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 18),
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
              colors: [AppColors.primary.withValues(alpha: 0.3), AppColors.primary.withValues(alpha: 0.1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Center(
            child: Text(
              entry.pahalwanRank,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
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
                : AppColors.grey200.withValues(alpha: 0.3),
            child: Text(
              entry.userName[0],
              style: TextStyle(
                color: entry.isCurrentUser ? AppColors.primary : AppColors.grey600,
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
                Text(
                  entry.pahalwanRank,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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
