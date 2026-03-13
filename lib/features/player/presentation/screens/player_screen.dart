import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/sample_data.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  bool _isPlaying = true;
  double _progress = 0.35;
  double _speed = 1.0;
  int _currentTab = 0;
  late AnimationController _rotateController;
  late AnimationController _pulseController;

  final episode = SampleData.sampleEpisodes[0];

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1117), Color(0xFF181B25), Color(0xFF0F1117)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30, color: AppColors.grey300),
                    ),
                    const Spacer(),
                    Text('Now Playing', style: AppTextStyles.overline.copyWith(color: AppColors.grey500)),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_rounded, color: AppColors.grey400),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // ── Vinyl Record Art ──
                      _buildVinylRecord(),

                      const SizedBox(height: 36),

                      // ── Title & Podcast ──
                      Text(
                        episode.title,
                        style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                      const SizedBox(height: 8),
                      Text(
                        episode.podcastName,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
                      ),

                      const SizedBox(height: 28),

                      // ── Progress bar ──
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.darkDivider,
                          thumbColor: AppColors.primary,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          trackHeight: 4,
                          overlayColor: AppColors.primary.withValues(alpha: 0.15),
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
                            Text(
                              _formatDuration((_progress * episode.durationSeconds).round()),
                              style: AppTextStyles.mono.copyWith(color: AppColors.grey500, fontSize: 11),
                            ),
                            Text(
                              _formatDuration(episode.durationSeconds),
                              style: AppTextStyles.mono.copyWith(color: AppColors.grey500, fontSize: 11),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Controls ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Speed
                          _ControlChip(
                            label: '${_speed}x',
                            onTap: () {
                              final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0];
                              final i = speeds.indexOf(_speed);
                              setState(() => _speed = speeds[(i + 1) % speeds.length]);
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: () => setState(() => _progress = (_progress - 0.05).clamp(0, 1)),
                            icon: const Icon(Icons.replay_10_rounded, size: 32, color: AppColors.grey300),
                          ),
                          const SizedBox(width: 12),
                          // Play/Pause
                          GestureDetector(
                            onTap: () => setState(() => _isPlaying = !_isPlaying),
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: _isPlaying ? 0.3 + _pulseController.value * 0.15 : 0.2,
                                        ),
                                        blurRadius: _isPlaying ? 20 + _pulseController.value * 8 : 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () => setState(() => _progress = (_progress + 0.05).clamp(0, 1)),
                            icon: const Icon(Icons.forward_30_rounded, size: 32, color: AppColors.grey300),
                          ),
                          const SizedBox(width: 16),
                          // Suno save
                          _ControlChip(
                            icon: Icons.bookmark_add_rounded,
                            color: AppColors.accent,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(children: [
                                    const Icon(Icons.bookmark_added, color: AppColors.accent),
                                    const SizedBox(width: 8),
                                    const Text('Suno! Clip saved 🎧'),
                                  ]),
                                  backgroundColor: AppColors.darkCard,
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── Action buttons ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionButton(icon: Icons.chat_bubble_outline_rounded, label: 'Ask Kaan'),
                          _ActionButton(icon: Icons.bedtime_outlined, label: 'Sleep Timer'),
                          _ActionButton(icon: Icons.queue_music_rounded, label: 'Queue'),
                          _ActionButton(icon: Icons.share_outlined, label: 'Share'),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Chapters / Transcript / AI Summary ──
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.darkCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.darkDivider.withValues(alpha: 0.5)),
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
                            Divider(height: 1, color: AppColors.darkDivider),
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

                      const SizedBox(height: 100),
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

  Widget _buildVinylRecord() {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _isPlaying ? _rotateController.value * 2 * pi : 0,
          child: child,
        );
      },
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [Color(0xFF2A2E3C), Color(0xFF1A1E28), Color(0xFF2A2E3C)],
            stops: [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Groove rings
            ...[120, 100, 80, 60].map((r) => Container(
                  width: r.toDouble(),
                  height: r.toDouble(),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.04),
                      width: 0.5,
                    ),
                  ),
                )),
            // Center label
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.headphones_rounded, color: Colors.white, size: 28),
                  const SizedBox(height: 2),
                  Text(
                    episode.category.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            // Outer ring
            Container(
              width: 258,
              height: 258,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(begin: const Offset(0.85, 0.85), duration: 600.ms, curve: Curves.easeOut);
  }

  Widget _buildChapters() {
    if (episode.chapters.isEmpty) {
      return Text('No chapters available', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500));
    }
    return Column(
      children: episode.chapters.map((ch) {
        final isActive = _progress * episode.durationSeconds >= ch.startSeconds &&
            _progress * episode.durationSeconds < ch.endSeconds;
        return InkWell(
          onTap: () => setState(() => _progress = ch.startSeconds / episode.durationSeconds),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  _formatDuration(ch.startSeconds),
                  style: AppTextStyles.mono.copyWith(
                    color: isActive ? AppColors.primary : AppColors.grey600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ch.title,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      color: isActive ? AppColors.primary : AppColors.grey300,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (isActive) const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 18),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTranscript() {
    return Text(
      'Welcome to Tech Talks India. Today we\'re discussing the future of AI in India, and what it means for every single person in this country.\n\nIn the last year alone, Indian AI startups raised over 3.2 billion dollars. That\'s not just a number – yeh toh revolution hai, bhai.\n\nLet\'s start with what\'s happening in the startup ecosystem. From Bangalore to Hyderabad, from IIT labs to garage startups, AI companies are being born every day...',
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey300, height: 1.8),
    );
  }

  Widget _buildAISummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.jade.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, size: 14, color: AppColors.jade),
              const SizedBox(width: 4),
              Text('AI Summary', style: AppTextStyles.labelSmall.copyWith(color: AppColors.jade)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          episode.aiSummary ?? 'No summary available',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey300, height: 1.7),
        ),
        const SizedBox(height: 16),
        Text('Key Takeaways', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
        const SizedBox(height: 8),
        ...[
          'Indian AI startups raised \$3.2B in 2025',
          'Government pushing AI in healthcare, agriculture',
          'Talent gap remains the biggest challenge',
          'Ethical AI frameworks gaining traction',
        ].map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.jade),
                  const SizedBox(width: 8),
                  Expanded(child: Text(t, style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey300))),
                ],
              ),
            )),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _ControlChip extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Color? color;
  final VoidCallback onTap;

  const _ControlChip({this.label, this.icon, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.withValues(alpha: 0.2)),
        ),
        child: icon != null
            ? Icon(icon, color: c, size: 20)
            : Text(label!, style: AppTextStyles.labelMedium.copyWith(color: c)),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22, color: AppColors.grey500),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.grey500, fontWeight: FontWeight.w600)),
      ],
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
