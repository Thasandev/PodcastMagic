import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart' as audio_pkg;

import 'package:kaan/core/theme/app_colors.dart';
import 'package:kaan/core/theme/app_text_styles.dart';
import 'package:kaan/core/models/models.dart';
import 'package:kaan/services/audio_service.dart';

class PlayerScreen extends ConsumerWidget {
  final Episode? initialEpisode;

  const PlayerScreen({super.key, this.initialEpisode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioService = ref.watch(audioServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Album Art
              StreamBuilder<audio_pkg.MediaItem?>(
                stream: audioService.mediaItemStream,
                builder: (context, snapshot) {
                  final mediaItem = snapshot.data;
                  final imageUrl = mediaItem?.artUri?.toString();

                  return Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: imageUrl != null
                          ? Image.network(imageUrl, fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholderArt())
                          : _buildPlaceholderArt(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Title & Artist
              StreamBuilder<audio_pkg.MediaItem?>(
                stream: audioService.mediaItemStream,
                builder: (context, snapshot) {
                  final mediaItem = snapshot.data;
                  return Column(
                    children: [
                      Text(
                        mediaItem?.title ?? 'Not Playing',
                        style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mediaItem?.artist ?? 'Select a podcast',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 48),
              // Progress Bar
              StreamBuilder<Duration>(
                stream: audio_pkg.AudioService.position,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  return StreamBuilder<audio_pkg.MediaItem?>(
                    stream: audioService.mediaItemStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data?.duration ?? Duration.zero;
                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.grey800,
                              thumbColor: Colors.white,
                            ),
                            child: Slider(
                              value: position.inMilliseconds.toDouble().clamp(
                                    0.0,
                                    duration.inMilliseconds.toDouble(),
                                  ),
                              max: duration.inMilliseconds.toDouble() == 0
                                  ? 1.0
                                  : duration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                audioService.seek(Duration(milliseconds: value.toInt()));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 32),
                    onPressed: () => audioService.rewind(),
                  ),
                  StreamBuilder<audio_pkg.PlaybackState>(
                    stream: audioService.playbackStateStream,
                    builder: (context, snapshot) {
                      final playing = snapshot.data?.playing ?? false;
                      return Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: IconButton(
                          icon: Icon(
                            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                          onPressed: () {
                            if (playing) {
                              audioService.pause();
                            } else {
                              audioService.play();
                            }
                          },
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_30_rounded, color: Colors.white, size: 32),
                    onPressed: () => audioService.fastForward(),
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderArt() {
    return Container(
      color: AppColors.grey900,
      child: const Icon(Icons.podcasts_rounded, color: AppColors.grey700, size: 100),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
