import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  bool _showOTP = false;
  bool _isLoading = false;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F1117),
              Color(0xFF151826),
              Color(0xFF0F1117),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // ── Vinyl Ring Motif ──
                  _buildVinylLogo(),

                  const SizedBox(height: 36),

                  // ── Brand name ──
                  Text(
                    'Kaan',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: Colors.white,
                      fontSize: 52,
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 6),

                  // ── Animated sound-wave tagline ──
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildWaveBar(0),
                      _buildWaveBar(1),
                      _buildWaveBar(2),
                      const SizedBox(width: 10),
                      Text(
                        'Your commute, your classroom',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey400,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildWaveBar(3),
                      _buildWaveBar(4),
                      _buildWaveBar(5),
                    ],
                  ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

                  const SizedBox(height: 60),

                  // ── Phone / OTP Section ──
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _showOTP ? _buildOTPSection() : _buildPhoneSection(),
                  ),

                  const SizedBox(height: 28),

                  // ── Divider ──
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.darkDivider)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or continue with',
                          style: AppTextStyles.caption,
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.darkDivider)),
                    ],
                  ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                  const SizedBox(height: 20),

                  // ── Social Buttons ──
                  Row(
                    children: [
                      Expanded(child: _SocialButton(icon: Icons.g_mobiledata_rounded, label: 'Google', onTap: () {})),
                      const SizedBox(width: 12),
                      Expanded(child: _SocialButton(icon: Icons.apple, label: 'Apple', onTap: () {})),
                    ],
                  ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.15, end: 0),

                  const SizedBox(height: 40),

                  // ── Terms ──
                  Text(
                    'By continuing, you agree to our Terms & Privacy Policy',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 700.ms),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVinylLogo() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3 + (_waveController.value * 0.15)),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 30 + (_waveController.value * 10),
                spreadRadius: _waveController.value * 5,
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(Icons.headphones_rounded, color: Colors.white, size: 36),
            ),
          ),
        );
      },
    ).animate().scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 800.ms, curve: Curves.easeOut);
  }

  Widget _buildWaveBar(int index) {
    final heights = [10.0, 16.0, 12.0, 14.0, 10.0, 16.0];
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, _) {
        final offset = (_waveController.value + index * 0.15) % 1.0;
        final h = heights[index] * (0.4 + 0.6 * (0.5 + 0.5 * (offset * 3.14159 * 2).abs().clamp(0, 1)));
        return Container(
          width: 2.5,
          height: h,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }

  Widget _buildPhoneSection() {
    return Column(
      key: const ValueKey('phone'),
      children: [
        // Frosted glass phone input
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkDivider),
              ),
              child: Row(
                children: [
                  Text('+91', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey300)),
                  Container(
                    width: 1,
                    height: 28,
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    color: AppColors.darkDivider,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, letterSpacing: 1.5),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Phone number',
                        hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey600),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideX(begin: -0.1, end: 0),

        const SizedBox(height: 18),

        KGradientButton(
          text: 'Send OTP',
          icon: Icons.arrow_forward_rounded,
          isLoading: _isLoading,
          onPressed: () {
            if (_phoneController.text.length >= 10) {
              setState(() => _showOTP = true);
            }
          },
        ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildOTPSection() {
    return Column(
      key: const ValueKey('otp'),
      children: [
        Text(
          'Enter verification code',
          style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          'Sent to +91 ${_phoneController.text}',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
        ),
        const SizedBox(height: 28),

        // OTP dots with coral glow
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (i) {
            return Container(
              width: 48,
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _otpControllers[i].text.isNotEmpty
                      ? AppColors.primary
                      : AppColors.darkDivider,
                  width: _otpControllers[i].text.isNotEmpty ? 2 : 1,
                ),
                boxShadow: _otpControllers[i].text.isNotEmpty
                    ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 10)]
                    : null,
              ),
              child: Center(
                child: TextField(
                  controller: _otpControllers[i],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  obscureText: true,
                  style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    if (val.isNotEmpty && i < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                    setState(() {});
                  },
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 24),

        KGradientButton(
          text: 'Verify & Continue',
          icon: Icons.check_rounded,
          isLoading: _isLoading,
          onPressed: () {},
        ),

        const SizedBox(height: 16),
        TextButton(
          onPressed: () => setState(() => _showOTP = false),
          child: Text(
            '← Change number',
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.grey400),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.15, end: 0);
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.darkDivider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.grey300, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.grey200),
            ),
          ],
        ),
      ),
    );
  }
}
