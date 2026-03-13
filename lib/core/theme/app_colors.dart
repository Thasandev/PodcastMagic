import 'package:flutter/material.dart';

/// Vinyl Lounge — Retro-futuristic palette for Kaan
class AppColors {
  AppColors._();

  // ─── Primary: Electric Coral ───
  static const Color primary = Color(0xFFFF6161);
  static const Color primaryLight = Color(0xFFFF8A8A);
  static const Color primaryDark = Color(0xFFD94444);

  // ─── Accent: Amber Gold ───
  static const Color accent = Color(0xFFF5A623);
  static const Color accentLight = Color(0xFFFFBF54);
  static const Color accentDark = Color(0xFFD48C10);

  // ─── Tertiary: Soft Jade ───
  static const Color jade = Color(0xFF7ECFB3);
  static const Color jadeLight = Color(0xFFA8E4D0);
  static const Color jadeDark = Color(0xFF54B08E);

  // ─── Secondary: Obsidian ───
  static const Color secondary = Color(0xFF0D0D12);
  static const Color secondaryLight = Color(0xFF2A2A35);
  static const Color secondaryDark = Color(0xFF050508);

  // ─── Neutrals ───
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF8F8FA);
  static const Color grey100 = Color(0xFFEDEDF2);
  static const Color grey200 = Color(0xFFD8D8E0);
  static const Color grey300 = Color(0xFFC0C0CC);
  static const Color grey400 = Color(0xFF9898A8);
  static const Color grey500 = Color(0xFF6E6E80);
  static const Color grey600 = Color(0xFF52525E);
  static const Color grey700 = Color(0xFF3A3A45);
  static const Color grey800 = Color(0xFF27272F);
  static const Color grey900 = Color(0xFF18181D);

  // ─── Light Mode Surfaces ───
  static const Color lightBackground = Color(0xFFFAF8F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFCF8);
  static const Color lightDivider = Color(0xFFE8E4DE);

  // ─── Dark Mode Surfaces ───
  static const Color darkBackground = Color(0xFF0F1117);
  static const Color darkSurface = Color(0xFF181B25);
  static const Color darkCard = Color(0xFF1E2230);
  static const Color darkDivider = Color(0xFF2A2E3C);

  // ─── Semantic ───
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFFF4D4D);
  static const Color info = Color(0xFF60A5FA);

  // ─── Gradients ───
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6161), Color(0xFFF5A623)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0F1117), Color(0xFF1E2230)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF5A623), Color(0xFFFF6161)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF5A623), Color(0xFFFFD700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient jadeGradient = LinearGradient(
    colors: [Color(0xFF7ECFB3), Color(0xFF54B08E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F1117), Color(0xFF1A1530), Color(0xFF0F1117)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x08FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Rank Colors ───
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color diamond = Color(0xFFB9F2FF);
}
