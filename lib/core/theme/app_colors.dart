import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Warm Orange (chai, energy, sunset)
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8F66);
  static const Color primaryDark = Color(0xFFE5521C);

  // Secondary - Deep Slate (stable, readable)
  static const Color secondary = Color(0xFF2E4057);
  static const Color secondaryLight = Color(0xFF4A5E78);
  static const Color secondaryDark = Color(0xFF1A2A3D);

  // Accent - Mint (success, progress)
  static const Color accent = Color(0xFF4ECDC4);
  static const Color accentLight = Color(0xFF7EDDD6);
  static const Color accentDark = Color(0xFF2DB5AB);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Light theme
  static const Color lightBackground = Color(0xFFFDF8F2);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFBF7);
  static const Color lightDivider = Color(0xFFE8E0D8);

  // Dark theme
  static const Color darkBackground = Color(0xFF1A1E24);
  static const Color darkSurface = Color(0xFF252A32);
  static const Color darkCard = Color(0xFF2D333B);
  static const Color darkDivider = Color(0xFF3D4450);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF8A65)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1E24), Color(0xFF2D333B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFF26D0CE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Rank colors
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color diamond = Color(0xFFB9F2FF);
}
