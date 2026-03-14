import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/shared_widgets.dart';

class RecordReflectionScreen extends StatefulWidget {
  const RecordReflectionScreen({super.key});

  @override
  State<RecordReflectionScreen> createState() => _RecordReflectionScreenState();
}

class _RecordReflectionScreenState extends State<RecordReflectionScreen>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _hasRecording = false;
  int _seconds = 0;
  Timer? _timer;
  String _visibility = 'public';
  late AnimationController _pulseController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      if (_isRecording) {
        _isRecording = false;
        _hasRecording = true;
        _timer?.cancel();
        _pulseController.stop();
        _waveController.stop();
      } else {
        _isRecording = true;
        _hasRecording = false;
        _seconds = 0;
        _pulseController.repeat(reverse: true);
        _waveController.repeat();
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (_seconds >= 120) {
            _toggleRecording();
          } else {
            setState(() => _seconds++);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1117), Color(0xFF151826), Color(0xFF0F1117)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.grey400,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Record Reflection',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const Spacer(),

              // ── Microphone / Waveform area ──
              _buildMicSection(),

              const SizedBox(height: 32),

              // Timer
              Text(
                '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}',
                style: AppTextStyles.mono.copyWith(
                  color: _isRecording ? AppColors.primary : AppColors.grey500,
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                _isRecording
                    ? 'Recording...'
                    : (_hasRecording ? 'Recording saved' : 'Tap to start'),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey500,
                ),
              ),

              const Spacer(),

              // ── Controls ──
              if (_hasRecording) ...[
                // Visibility toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _VisibilityChip(
                      label: '🌍 Public',
                      isSelected: _visibility == 'public',
                      onTap: () => setState(() => _visibility = 'public'),
                    ),
                    const SizedBox(width: 12),
                    _VisibilityChip(
                      label: '👥 Friends Only',
                      isSelected: _visibility == 'friends',
                      onTap: () => setState(() => _visibility = 'friends'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _hasRecording = false;
                              _seconds = 0;
                            });
                          },
                          icon: const Icon(Icons.replay_rounded),
                          label: const Text('Re-record'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.grey300,
                            side: const BorderSide(
                              color: AppColors.darkDivider,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: KGradientButton(
                          text: 'Share ✨',
                          height: 52,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reflection shared! 🎙️'),
                                backgroundColor: AppColors.darkCard,
                              ),
                            );
                            context.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Record button
                GestureDetector(
                  onTap: _toggleRecording,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _isRecording
                              ? null
                              : AppColors.primaryGradient,
                          color: _isRecording ? AppColors.error : null,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (_isRecording
                                          ? AppColors.error
                                          : AppColors.primary)
                                      .withValues(
                                        alpha: _isRecording
                                            ? 0.3 + _pulseController.value * 0.2
                                            : 0.3,
                                      ),
                              blurRadius: _isRecording
                                  ? 20 + _pulseController.value * 10
                                  : 20,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMicSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Concentric rings
        ...List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              final scale =
                  1.0 +
                  i * 0.25 +
                  (_isRecording ? _pulseController.value * 0.1 : 0);
              return Container(
                width: 160 * scale,
                height: 160 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(
                      alpha: _isRecording ? 0.25 - i * 0.07 : 0.08 - i * 0.02,
                    ),
                    width: 1,
                  ),
                ),
              );
            },
          );
        }),
        // Center icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.darkCard,
            border: Border.all(
              color: _isRecording
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.darkDivider,
              width: 2,
            ),
            boxShadow: _isRecording
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 20,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.mic_rounded,
            size: 48,
            color: _isRecording ? AppColors.primary : AppColors.grey500,
          ),
        ),
      ],
    ).animate().scale(
      begin: const Offset(0.8, 0.8),
      duration: 500.ms,
      curve: Curves.easeOut,
    );
  }
}

class _VisibilityChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VisibilityChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkDivider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.grey400,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
