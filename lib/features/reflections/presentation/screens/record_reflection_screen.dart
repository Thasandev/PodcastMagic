import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shared_widgets.dart';

class RecordReflectionScreen extends StatefulWidget {
  const RecordReflectionScreen({super.key});

  @override
  State<RecordReflectionScreen> createState() => _RecordReflectionScreenState();
}

class _RecordReflectionScreenState extends State<RecordReflectionScreen>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  int _recordingSeconds = 0;
  bool _isPublic = true;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isRecording || !mounted) return false;
      setState(() => _recordingSeconds++);
      if (_recordingSeconds >= 60) {
        setState(() => _isRecording = false);
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Chai Break'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Share what you learned',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Record up to 60 seconds of your thoughts',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: 48),

            // Recording indicator
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = _isRecording ? 1.0 + (_pulseController.value * 0.1) : 1.0;
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording
                      ? AppColors.error.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.1),
                  border: Border.all(
                    color: _isRecording ? AppColors.error : AppColors.primary,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      size: 48,
                      color: _isRecording ? AppColors.error : AppColors.primary,
                    ),
                    if (_isRecording) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${_recordingSeconds}s / 60s',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Record button
            KGradientButton(
              text: _isRecording ? 'Stop Recording' : 'Start Recording',
              icon: _isRecording ? Icons.stop : Icons.mic,
              gradient: _isRecording ? const LinearGradient(colors: [AppColors.error, Color(0xFFFF5252)]) : null,
              onPressed: _toggleRecording,
            ),

            const SizedBox(height: 24),

            // Visibility toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('🌍 Public'),
                  selected: _isPublic,
                  onSelected: (val) => setState(() => _isPublic = true),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('👥 Friends Only'),
                  selected: !_isPublic,
                  onSelected: (val) => setState(() => _isPublic = false),
                  selectedColor: AppColors.accent.withValues(alpha: 0.2),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(
              _isPublic
                  ? 'Your reflection will appear in the Community Wisdom Feed'
                  : 'Only your friends will see this reflection',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),

            if (_recordingSeconds > 0 && !_isRecording) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _recordingSeconds = 0);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Re-record'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KGradientButton(
                      text: 'Share',
                      icon: Icons.send,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('☕ Reflection shared! +15 Kaan Coins'),
                            backgroundColor: AppColors.accent,
                          ),
                        );
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
