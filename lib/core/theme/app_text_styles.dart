import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Vinyl Lounge Typography — Playfair Display (editorial) + DM Sans (humanist)
class AppTextStyles {
  AppTextStyles._();

  // ═══ Display/Headlines — Playfair Display ═══
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.5,
    height: 1.1,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.15,
  );

  static TextStyle get displaySmall => GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static TextStyle get headlineLarge => GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.25,
  );

  static TextStyle get headlineMedium => GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
  );

  static TextStyle get headlineSmall =>
      GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700);

  // ═══ Body — DM Sans ═══
  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ═══ Labels — DM Sans ═══
  static TextStyle get labelLarge => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );

  static TextStyle get labelMedium => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );

  static TextStyle get labelSmall => GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // ═══ Special Styles ═══
  static TextStyle get button => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
  );

  static TextStyle get caption => GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.grey500,
  );

  static TextStyle get overline => GoogleFonts.dmMono(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 2.0,
  );

  static TextStyle get coinBalance => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.accent,
  );

  static TextStyle get streakCount => GoogleFonts.playfairDisplay(
    fontSize: 52,
    fontWeight: FontWeight.w900,
    color: AppColors.primary,
  );

  static TextStyle get mono => GoogleFonts.dmMono(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}
