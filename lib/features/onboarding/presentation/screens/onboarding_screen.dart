import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/shared_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Selections
  final Set<String> _selectedLanguages = {'en'};
  final Set<String> _selectedInterests = {};
  double _commuteDuration = 30;
  String _selectedVoice = 'natural';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1117), Color(0xFF151826), Color(0xFF0F1117)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Progress + Back ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      IconButton(
                        onPressed: _previousPage,
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.grey400,
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(child: _buildProgressDots()),
                    Text(
                      '${_currentPage + 1}/5',
                      style: AppTextStyles.mono.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Pages ──
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  children: [
                    _buildWelcomePage(),
                    _buildLanguagePage(),
                    _buildInterestsPage(),
                    _buildCommutePage(),
                    _buildVoicePage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final isActive = i == _currentPage;
        final isPast = i < _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: isActive ? AppColors.primaryGradient : null,
            color: isActive
                ? null
                : (isPast
                      ? AppColors.primary.withValues(alpha: 0.4)
                      : AppColors.darkDivider),
          ),
        );
      }),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Vinyl icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 30,
                ),
              ],
            ),
            child: const Icon(
              Icons.headphones_rounded,
              color: Colors.white,
              size: 48,
            ),
          ).animate().scale(
            begin: const Offset(0.6, 0.6),
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 40),
          Text(
            'Let\'s make your\ncommute count',
            style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          const SizedBox(height: 12),
          Text(
            'A few quick questions to personalize\nyour listening experience',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey400),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
          const SizedBox(height: 60),
          KGradientButton(text: 'Let\'s go →', onPressed: _nextPage)
              .animate()
              .fadeIn(delay: 600.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildLanguagePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'What languages\ndo you speak?',
            style: AppTextStyles.displaySmall.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll find podcasts in your preferred languages',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: AppConstants.supportedLanguages.length,
            itemBuilder: (context, index) {
              final lang = AppConstants.supportedLanguages[index];
              final isSelected = _selectedLanguages.contains(lang['code']);
              return _SelectableChip(
                title: lang['nativeName']!,
                subtitle: lang['name']!,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected && _selectedLanguages.length > 1) {
                      _selectedLanguages.remove(lang['code']);
                    } else {
                      _selectedLanguages.add(lang['code']!);
                    }
                  });
                },
              );
            },
          ),
          const SizedBox(height: 32),
          KGradientButton(text: 'Continue →', onPressed: _nextPage),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInterestsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'What are you\ninto?',
            style: AppTextStyles.displaySmall.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Pick at least 3 topics. We\'ll curate your feed.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: AppConstants.interestCategories.length,
            itemBuilder: (context, index) {
              final cat = AppConstants.interestCategories[index];
              final isSelected = _selectedInterests.contains(cat['id']);
              return _SelectableChip(
                title: '${cat['icon']}  ${cat['name']}',
                isSelected: isSelected,
                selectedColor: Color(cat['color'] as int),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedInterests.remove(cat['id']);
                    } else {
                      _selectedInterests.add(cat['id'] as String);
                    }
                  });
                },
              );
            },
          ),
          const SizedBox(height: 32),
          KGradientButton(
            text: 'Continue →',
            onPressed: _selectedInterests.length >= 3 ? _nextPage : () {},
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCommutePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How long is\nyour commute?',
            style: AppTextStyles.displaySmall.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll fit episodes perfectly to your journey',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          // Big number display
          Text(
            '${_commuteDuration.round()}',
            style: AppTextStyles.streakCount.copyWith(
              color: AppColors.accent,
              fontSize: 72,
            ),
          ),
          Text(
            'minutes',
            style: AppTextStyles.overline.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 32),
          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.darkDivider,
              thumbColor: AppColors.primary,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayColor: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: Slider(
              value: _commuteDuration,
              min: AppConstants.minCommuteDuration.toDouble(),
              max: AppConstants.maxCommuteDuration.toDouble(),
              divisions: 21,
              onChanged: (val) => setState(() => _commuteDuration = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('15 min', style: AppTextStyles.caption),
                Text('120 min', style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(height: 48),
          KGradientButton(text: 'Continue →', onPressed: _nextPage),
        ],
      ),
    );
  }

  Widget _buildVoicePage() {
    final voices = [
      {
        'id': 'natural',
        'name': 'Natural',
        'desc': 'Warm, conversational',
        'icon': '🎙️',
      },
      {
        'id': 'professional',
        'name': 'Professional',
        'desc': 'Clear, authoritative',
        'icon': '🎧',
      },
      {
        'id': 'friendly',
        'name': 'Friendly',
        'desc': 'Casual, upbeat',
        'icon': '😊',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose your\nlistening vibe',
            style: AppTextStyles.displaySmall.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'How should Kaan sound to you?',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ...voices.map((voice) {
            final isSelected = _selectedVoice == voice['id'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SelectableChip(
                title: '${voice['icon']}  ${voice['name']}',
                subtitle: voice['desc'],
                isSelected: isSelected,
                onTap: () => setState(() => _selectedVoice = voice['id']!),
              ),
            );
          }),
          const SizedBox(height: 32),
          KGradientButton(
            text: 'Start Listening 🎧',
            onPressed: () {
              // Navigate to main app
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isSelected;
  final Color? selectedColor;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.title,
    this.subtitle,
    required this.isSelected,
    this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selectedColor ?? AppColors.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : AppColors.darkDivider,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isSelected ? color : AppColors.grey300,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected
                        ? color.withValues(alpha: 0.7)
                        : AppColors.grey600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
