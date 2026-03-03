import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/sample_data.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with SingleTickerProviderStateMixin {
  bool _isPlaying = true;
  double _progress = 0.35;
  double _speed = 1.0;
  int _currentTab = 0; // 0 = chapters, 1 = transcript, 2 = AI Summary
  late AnimationController _pulseController;

  final episode = SampleData.sampleEpisodes[0];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1E24), const Color(0xFF2D333B), const Color(0xFF1A1E24)]
                : [const Color(0xFFFDF8F2), const Color(0xFFFFEDE0), const Color(0xFFFDF8F2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 30),
                    ),
                    const Spacer(),
                    Text('Now Playing', style: Theme.of(context).textTheme.labelLarge),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Album art
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale = 1.0 + (_pulseController.value * 0.02);
                          return Transform.scale(
                            scale: _isPlaying ? scale : 1.0,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFFF3D00), Color(0xFFFF8F66)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 40,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.headphones, color: Colors.white24, size: 120),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.headphones, color: Colors.white, size: 56),
                                  const SizedBox(height: 8),
                                  Text(
                                    episode.category.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title & podcast
                      Text(
                        episode.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        episode.podcastName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
                      ),

                      const SizedBox(height: 24),

                      // Progress bar
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.grey300.withValues(alpha: 0.3),
                          thumbColor: AppColors.primary,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          trackHeight: 4,
                          overlayColor: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: _progress,
                          onChanged: (val) => setState(() => _progress = val),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration((_progress * episode.durationSeconds).round()),
                                style: Theme.of(context).textTheme.labelSmall),
                            Text(_formatDuration(episode.durationSeconds),
                                style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Speed
                          InkWell(
                            onTap: () {
                              final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0];
                              final currentIndex = speeds.indexOf(_speed);
                              setState(() {
                                _speed = speeds[(currentIndex + 1) % speeds.length];
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${_speed}x',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Skip back
                          IconButton(
                            onPressed: () {
                              setState(() => _progress = (_progress - 0.05).clamp(0, 1));
                            },
                            icon: const Icon(Icons.replay_10, size: 32),
                          ),
                          const SizedBox(width: 12),
                          // Play/Pause
                          InkWell(
                            onTap: () => setState(() => _isPlaying = !_isPlaying),
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Skip forward
                          IconButton(
                            onPressed: () {
                              setState(() => _progress = (_progress + 0.05).clamp(0, 1));
                            },
                            icon: const Icon(Icons.forward_30, size: 32),
                          ),
                          const SizedBox(width: 20),
                          // Suno save button
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.bookmark_added, color: AppColors.accent),
                                      const SizedBox(width: 8),
                                      const Text('Suno! Clip saved 🎧'),
                                    ],
                                  ),
                                  backgroundColor: AppColors.secondary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.bookmark_add, color: AppColors.accent, size: 22),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Action buttons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionButton(icon: Icons.chat_bubble_outline, label: 'Ask Kaan', onTap: () {}),
                          _ActionButton(icon: Icons.bedtime_outlined, label: 'Sleep Timer', onTap: () {}),
                          _ActionButton(icon: Icons.queue_music, label: 'Queue', onTap: () {}),
                          _ActionButton(icon: Icons.share_outlined, label: 'Share', onTap: () {}),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Tab section: Chapters / Transcript / AI Summary
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _TabButton(label: 'Chapters', isSelected: _currentTab == 0, onTap: () => setState(() => _currentTab = 0)),
                                _TabButton(label: 'Transcript', isSelected: _currentTab == 1, onTap: () => setState(() => _currentTab = 1)),
                                _TabButton(label: 'AI Summary', isSelected: _currentTab == 2, onTap: () => setState(() => _currentTab = 2)),
                              ],
                            ),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: _currentTab == 0
                                  ? _buildChapters()
                                  : _currentTab == 1
                                      ? _buildTranscript()
                                      : _buildAISummary(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChapters() {
    if (episode.chapters.isEmpty) {
      return const Text('No chapters available');
    }
    return Column(
      children: episode.chapters.map((ch) {
        final isActive = _progress * episode.durationSeconds >= ch.startSeconds &&
            _progress * episode.durationSeconds < ch.endSeconds;
        return InkWell(
          onTap: () {
            setState(() => _progress = ch.startSeconds / episode.durationSeconds);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  _formatDuration(ch.startSeconds),
                  style: TextStyle(
                    color: isActive ? AppColors.primary : AppColors.grey500,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ch.title,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      color: isActive ? AppColors.primary : null,
                    ),
                  ),
                ),
                if (isActive) const Icon(Icons.play_arrow, color: AppColors.primary, size: 18),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTranscript() {
    return Text(
      'Welcome to Tech Talks India. Today we\'re discussing the future of AI in India, and what it means for every single person in this country.\n\nIn the last year alone, Indian AI startups raised over 3.2 billion dollars. That\'s not just a number – yeh toh revolution hai, bhai.\n\nLet\'s start with what\'s happening in the startup ecosystem. From Bangalore to Hyderabad, from IIT labs to garage startups, AI companies are being born every day...\n\nThe government is also pushing hard. The India AI Mission has allocated significant budget for healthcare and agriculture applications...\n\n[Real-time transcript would appear here with word-by-word highlighting synchronized to audio playback]',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.8),
    );
  }

  Widget _buildAISummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 16, color: AppColors.accent),
              SizedBox(width: 4),
              Text('AI Generated Summary', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          episode.aiSummary ?? 'No summary available',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.7),
        ),
        const SizedBox(height: 16),
        Text(
          'Key Takeaways',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const _TakeawayItem(text: 'Indian AI startups raised \$3.2B in 2025'),
        const _TakeawayItem(text: 'Government pushing AI in healthcare, agriculture'),
        const _TakeawayItem(text: 'Talent gap remains the biggest challenge'),
        const _TakeawayItem(text: 'Ethical AI frameworks gaining traction'),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(icon, size: 22, color: AppColors.grey500),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: AppColors.grey500, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.grey500,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _TakeawayItem extends StatelessWidget {
  final String text;
  const _TakeawayItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppColors.accent),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}
