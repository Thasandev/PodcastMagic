import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../services/supabase_service.dart';
import '../../data/repositories/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  final _phoneController = TextEditingController();
  bool _otpSent = false;
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpObscureStates = List.generate(6, (_) => false);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
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
            colors: [Color(0xFF1A1E24), Color(0xFF2D333B), Color(0xFF1A1E24)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.08),
                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.headphones_rounded, color: Colors.white, size: 48),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Kaan',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your commute, your classroom',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                    ),
                    SizedBox(height: size.height * 0.06),

                    if (!_otpSent) ...[
                      // Phone input
                      _buildPhoneSection(),
                    ] else ...[
                      // OTP input
                      _buildOtpSection(),
                    ],

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.2))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or continue with',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.2))),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Social logins
                    Row(
                      children: [
                        Expanded(
                          child: _SocialButton(
                            icon: Icons.g_mobiledata,
                            label: 'Google',
                            onTap: () => _skipToOnboarding(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SocialButton(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            onTap: () => _skipToOnboarding(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Skip for now
                    TextButton(
                      onPressed: () => _skipToOnboarding(),
                      child: Text(
                        'Skip for now →',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.12))),
                ),
                child: const Text(
                  '🇮🇳 +91',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'Enter mobile number',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        KGradientButton(
          text: 'Send OTP',
          icon: Icons.sms_outlined,
          isLoading: _isLoading,
          onPressed: () async {
            if (_phoneController.text.length != 10) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid 10-digit mobile number'),
                  backgroundColor: Colors.redAccent,
                ),
              );
              return;
            }
            
            setState(() {
              _isLoading = true;
            });
            
            final authRepo = ref.read(authRepositoryProvider);
            final fullPhoneNumber = '+91${_phoneController.text}';
            
            try {
              await authRepo.sendOTP(
                phoneNumber: fullPhoneNumber,
                onCodeSent: () {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                      _otpSent = true;
                    });
                  }
                },
                onAutoVerify: (String code) async {
                  // In case of automatic SMS retrieval on Android
                  if (mounted) {
                    // Populate the UI
                    for (int i = 0; i < code.length && i < _otpControllers.length; i++) {
                      _otpControllers[i].text = code[i];
                    }
                    _verifyOtp(code);
                  }
                },
                onError: (String errorMessage) {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage), backgroundColor: Colors.redAccent),
                    );
                  }
                },
              );
            } catch (e) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildOtpSection() {
    return Column(
      children: [
        Text(
          'Enter the 6-digit OTP sent to',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          '+91 ${_phoneController.text}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            6,
            (i) => Container(
              width: 46,
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _otpControllers[i].text.isNotEmpty 
                      ? AppColors.primary.withValues(alpha: 0.5) 
                      : Colors.white.withValues(alpha: 0.15),
                  width: 1.5,
                ),
                boxShadow: _otpControllers[i].text.isNotEmpty ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ] : null,
              ),
              child: TextField(
                controller: _otpControllers[i],
                textAlign: TextAlign.center,
                obscureText: _otpObscureStates[i],
                obscuringCharacter: '●',
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 22, 
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      _otpObscureStates[i] = false;
                    });
                    
                    // Delay obscuring for a brief "show" effect
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (mounted && _otpControllers[i].text.isNotEmpty) {
                        setState(() {
                          _otpObscureStates[i] = true;
                        });
                      }
                    });

                    if (i < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                  } else {
                    setState(() {
                      _otpObscureStates[i] = false;
                    });
                    if (i > 0) {
                      FocusScope.of(context).previousFocus();
                    }
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: Text(
            'Resend OTP in 30s',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          ),
        ),
        const SizedBox(height: 16),
        KGradientButton(
          text: 'Verify & Continue',
          icon: Icons.check_circle_outline,
          isLoading: _isLoading,
          onPressed: () {
            final otp = _otpControllers.map((c) => c.text).join();
            if (otp.length != 6) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid 6-digit OTP'), backgroundColor: Colors.redAccent),
              );
              return;
            }
            _verifyOtp(otp);
          },
        ),
      ],
    );
  }

  Future<void> _verifyOtp(String otp) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.verifyOTP(otp);
      
      // Check if onboarding is completed
      final profile = await ref.read(supabaseServiceProvider).getProfile();
      final hasCompletedOnboarding = profile?.onboardingCompleted ?? false;

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        if (hasCompletedOnboarding) {
          context.go('/');
        } else {
          _skipToOnboarding();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _skipToOnboarding() {
    context.go('/onboarding');
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
