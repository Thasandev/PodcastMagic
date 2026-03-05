import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';
import 'shared_widgets.dart';

class LanguagePickerDialog extends StatefulWidget {
  final Set<String> initialLanguages;
  final Function(Set<String>) onSaved;

  const LanguagePickerDialog({
    super.key,
    required this.initialLanguages,
    required this.onSaved,
  });

  @override
  State<LanguagePickerDialog> createState() => _LanguagePickerDialogState();
}

class _LanguagePickerDialogState extends State<LanguagePickerDialog> {
  late Set<String> _selectedLanguages;

  @override
  void initState() {
    super.initState();
    _selectedLanguages = Set.from(widget.initialLanguages);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1E24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Languages 🌏',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: AppConstants.supportedLanguages.length,
                  itemBuilder: (context, index) {
                    final lang = AppConstants.supportedLanguages[index];
                    final isSelected = _selectedLanguages.contains(lang['code']);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            if (_selectedLanguages.length > 1) {
                              _selectedLanguages.remove(lang['code']);
                            }
                          } else {
                            _selectedLanguages.add(lang['code']!);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                lang['nativeName']!,
                                style: TextStyle(
                                  color: isSelected ? AppColors.primary : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                lang['name']!,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KGradientButton(
                    text: 'Save',
                    onPressed: () {
                      widget.onSaved(_selectedLanguages);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InterestPickerDialog extends StatefulWidget {
  final Set<String> initialInterests;
  final Function(Set<String>) onSaved;

  const InterestPickerDialog({
    super.key,
    required this.initialInterests,
    required this.onSaved,
  });

  @override
  State<InterestPickerDialog> createState() => _InterestPickerDialogState();
}

class _InterestPickerDialogState extends State<InterestPickerDialog> {
  late Set<String> _selectedInterests;

  @override
  void initState() {
    super.initState();
    _selectedInterests = Set.from(widget.initialInterests);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1E24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What interests you? 🎯',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: AppConstants.interestCategories.length,
                  itemBuilder: (context, index) {
                    final cat = AppConstants.interestCategories[index];
                    final isSelected = _selectedInterests.contains(cat['id']);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedInterests.remove(cat['id']);
                          } else {
                            _selectedInterests.add(cat['id'] as String);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(cat['color'] as int).withValues(alpha: 0.15)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Color(cat['color'] as int)
                                : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(cat['icon'] as String, style: const TextStyle(fontSize: 22)),
                              const SizedBox(height: 4),
                              Text(
                                cat['name'] as String,
                                style: TextStyle(
                                  color: isSelected
                                      ? Color(cat['color'] as int)
                                      : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KGradientButton(
                    text: 'Save',
                    onPressed: () {
                      widget.onSaved(_selectedInterests);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommuteDurationDialog extends StatefulWidget {
  final double initialDuration;
  final Function(double) onSaved;

  const CommuteDurationDialog({
    super.key,
    required this.initialDuration,
    required this.onSaved,
  });

  @override
  State<CommuteDurationDialog> createState() => _CommuteDurationDialogState();
}

class _CommuteDurationDialogState extends State<CommuteDurationDialog> {
  late double _duration;

  @override
  void initState() {
    super.initState();
    _duration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1E24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text(
        'Commute Duration 🚇',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_duration.round()} min',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
              thumbColor: AppColors.primary,
              trackHeight: 4,
            ),
            child: Slider(
              value: _duration,
              min: AppConstants.minCommuteDuration.toDouble(),
              max: AppConstants.maxCommuteDuration.toDouble(),
              divisions: 21,
              onChanged: (val) => setState(() => _duration = val),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('15m', style: TextStyle(color: Colors.white38, fontSize: 12)),
              Text('120m', style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        KGradientButton(
          text: 'Save',
          onPressed: () {
            widget.onSaved(_duration);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
