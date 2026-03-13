import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/widgets/shared_widgets.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool _isPlaying = true;

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/discover')) return 1;
    if (location.startsWith('/library')) return 2;
    if (location.startsWith('/dangal')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Glassmorphic Mini Player ──
          KMiniPlayer(
            title: SampleData.sampleEpisodes[0].title,
            podcastName: SampleData.sampleEpisodes[0].podcastName,
            isPlaying: _isPlaying,
            progress: 0.35,
            onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
            onTap: () => context.push('/player'),
          ),

          // ── Glassmorphic Bottom Nav ──
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.darkSurface.withValues(alpha: 0.88),
                  border: Border(
                    top: BorderSide(color: AppColors.darkDivider.withValues(alpha: 0.3)),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _NavItem(
                          icon: Icons.home_rounded,
                          label: 'Home',
                          isActive: selectedIndex == 0,
                          onTap: () => context.go('/'),
                        ),
                        _NavItem(
                          icon: Icons.explore_rounded,
                          label: 'Discover',
                          isActive: selectedIndex == 1,
                          onTap: () => context.go('/discover'),
                        ),
                        _NavItem(
                          icon: Icons.library_music_rounded,
                          label: 'Library',
                          isActive: selectedIndex == 2,
                          onTap: () => context.go('/library'),
                        ),
                        _NavItem(
                          icon: Icons.emoji_events_rounded,
                          label: 'Dangal',
                          isActive: selectedIndex == 3,
                          onTap: () => context.go('/dangal'),
                        ),
                        _NavItem(
                          icon: Icons.person_rounded,
                          label: 'Profile',
                          isActive: selectedIndex == 4,
                          onTap: () => context.go('/profile'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Glow dot above active
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isActive ? 20 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                gradient: isActive ? AppColors.primaryGradient : null,
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive
                    ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 8)]
                    : null,
              ),
            ),
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.grey600,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
