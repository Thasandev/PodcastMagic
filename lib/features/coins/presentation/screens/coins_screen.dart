import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class CoinsScreen extends StatelessWidget {
  const CoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SampleData.sampleUser;
    final transactions = SampleData.sampleCoinHistory;


    return Scaffold(
      appBar: AppBar(
        title: const Text('🪙 Kaan Coins'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          // Balance card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Your Balance',
                  style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.kaanCoins}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Kaan Coins',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Earn more section
          Text('Earn More Coins', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          _EarnCard(icon: '🔥', title: 'Daily Streak', subtitle: 'Day ${user.currentStreak + 1}: Earn 20 coins', coins: 20),
          _EarnCard(icon: '📱', title: 'Daily Login', subtitle: 'Come back tomorrow', coins: 10),
          _EarnCard(icon: '☕', title: 'Share Reflection', subtitle: 'Record and share your thoughts', coins: 15),
          _EarnCard(icon: '👥', title: 'Refer a Friend', subtitle: 'Share your invite link', coins: 100),
          _EarnCard(icon: '🧠', title: 'Complete Quiz', subtitle: 'Test your knowledge', coins: 25),

          const SizedBox(height: 24),

          // Redeem section
          Text('Redeem', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          _RedeemCard(icon: '⭐', title: '1 Day Premium', cost: 50, color: AppColors.primary),
          _RedeemCard(icon: '🍕', title: 'Zomato ₹100 Voucher', cost: 200, color: AppColors.error),
          _RedeemCard(icon: '👕', title: 'Myntra ₹200 Voucher', cost: 400, color: AppColors.accent),
          _RedeemCard(icon: '🌱', title: 'Plant a Tree', cost: 100, color: AppColors.success),
          _RedeemCard(icon: '🍽️', title: 'Feed a Child (1 meal)', cost: 150, color: AppColors.warning),

          const SizedBox(height: 24),

          // Transaction history
          Text('Transaction History', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          ...transactions.map((tx) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: KCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: tx.type == 'earned'
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.error.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          tx.type == 'earned' ? Icons.add : Icons.remove,
                          color: tx.type == 'earned' ? AppColors.success : AppColors.error,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx.reason, style: Theme.of(context).textTheme.titleSmall),
                            Text(
                              _timeAgo(tx.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${tx.amount > 0 ? '+' : ''}${tx.amount}',
                        style: TextStyle(
                          color: tx.type == 'earned' ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
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

class _EarnCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final int coins;

  const _EarnCard({required this.icon, required this.title, required this.subtitle, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: KCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+$coins 🪙',
                style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RedeemCard extends StatelessWidget {
  final String icon;
  final String title;
  final int cost;
  final Color color;

  const _RedeemCard({required this.icon, required this.title, required this.cost, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: KCard(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Redeemed: $title'), backgroundColor: color),
          );
        },
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleSmall),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                minimumSize: Size.zero,
              ),
              child: Text(
                '$cost 🪙',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
