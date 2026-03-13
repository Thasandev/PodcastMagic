import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

/// ═══════════════════════════════════════════════════════════════
///  Dialect Pickers — Redesigned with Vinyl Lounge aesthetic
/// ═══════════════════════════════════════════════════════════════

Future<Set<String>?> showLanguagePicker(BuildContext context, Set<String> initial) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    backgroundColor: AppColors.darkCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (context) => _LanguagePickerSheet(initial: initial),
  );
}

Future<Set<String>?> showInterestPicker(BuildContext context, Set<String> initial) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    backgroundColor: AppColors.darkCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (context) => _InterestPickerSheet(initial: initial),
  );
}

Future<double?> showCommuteDurationPicker(BuildContext context, double initial) {
  return showModalBottomSheet<double>(
    context: context,
    backgroundColor: AppColors.darkCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _CommuteDurationSheet(initial: initial),
  );
}

class _LanguagePickerSheet extends StatefulWidget {
  final Set<String> initial;
  const _LanguagePickerSheet({required this.initial});

  @override
  State<_LanguagePickerSheet> createState() => _LanguagePickerSheetState();
}

class _LanguagePickerSheetState extends State<_LanguagePickerSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.initial};
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, controller) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey700, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),
              Text('Languages', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 4),
              Text('Select your preferred languages', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500)),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  controller: controller,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: AppConstants.supportedLanguages.length,
                  itemBuilder: (context, index) {
                    final lang = AppConstants.supportedLanguages[index];
                    final isSelected = _selected.contains(lang['code']);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected && _selected.length > 1) {
                            _selected.remove(lang['code']);
                          } else {
                            _selected.add(lang['code']!);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.darkDivider),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(lang['nativeName']!, style: TextStyle(fontWeight: FontWeight.w700, color: isSelected ? AppColors.primary : AppColors.grey300)),
                              Text(lang['name']!, style: TextStyle(fontSize: 11, color: AppColors.grey500)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(_selected),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InterestPickerSheet extends StatefulWidget {
  final Set<String> initial;
  const _InterestPickerSheet({required this.initial});

  @override
  State<_InterestPickerSheet> createState() => _InterestPickerSheetState();
}

class _InterestPickerSheetState extends State<_InterestPickerSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.initial};
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, controller) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey700, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),
              Text('Interests', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 4),
              Text('Pick at least 3 topics', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500)),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  controller: controller,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: AppConstants.interestCategories.length,
                  itemBuilder: (context, index) {
                    final cat = AppConstants.interestCategories[index];
                    final isSelected = _selected.contains(cat['id']);
                    final color = Color(cat['color'] as int);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selected.remove(cat['id']);
                          } else {
                            _selected.add(cat['id'] as String);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected ? color.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isSelected ? color : AppColors.darkDivider),
                        ),
                        child: Center(
                          child: Text(
                            '${cat['icon']}  ${cat['name']}',
                            style: TextStyle(fontWeight: FontWeight.w700, color: isSelected ? color : AppColors.grey300),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selected.length >= 3 ? () => Navigator.of(context).pop(_selected) : null,
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CommuteDurationSheet extends StatefulWidget {
  final double initial;
  const _CommuteDurationSheet({required this.initial});

  @override
  State<_CommuteDurationSheet> createState() => _CommuteDurationSheetState();
}

class _CommuteDurationSheetState extends State<_CommuteDurationSheet> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey700, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text('Commute Duration', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 32),
          Text(
            '${_value.round()}',
            style: AppTextStyles.streakCount.copyWith(color: AppColors.accent, fontSize: 52),
          ),
          Text('minutes', style: AppTextStyles.overline.copyWith(color: AppColors.grey500)),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.darkDivider,
              thumbColor: AppColors.primary,
              trackHeight: 4,
            ),
            child: Slider(
              value: _value,
              min: AppConstants.minCommuteDuration.toDouble(),
              max: AppConstants.maxCommuteDuration.toDouble(),
              divisions: 21,
              onChanged: (val) => setState(() => _value = val),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(_value),
              child: const Text('Done'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
