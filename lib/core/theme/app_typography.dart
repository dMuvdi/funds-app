import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // Display — Instrument Serif (hero amounts, modal titles)
  static TextStyle get displayLarge => GoogleFonts.instrumentSerif(
    fontSize: 72,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    letterSpacing: -1.5,
    height: 1.0,
  );

  static TextStyle get displayMedium => GoogleFonts.instrumentSerif(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    letterSpacing: -0.3,
    height: 1.1,
  );

  // Headline — Inter semibold
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.2,
  );

  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.1,
  );

  static TextStyle get headlineSmall => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.01,
  );

  // Title — Inter medium/semibold
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  // Body — Inter regular
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    height: 1.45,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
    height: 1.45,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
    height: 1.5,
  );

  // Label — Inter
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.005,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.04,
  );

  // Kicker / eyebrow — uppercase mono label
  static TextStyle get kicker => GoogleFonts.jetBrainsMono(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.muted2,
    letterSpacing: 0.1,
  );

  // Mono — JetBrains Mono for ids, meta, axis
  static TextStyle get mono => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.muted2,
    letterSpacing: 0.04,
  );

  static TextStyle get monoSmall => GoogleFonts.jetBrainsMono(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.muted2,
    letterSpacing: 0.04,
  );

  // Number styles (legacy names kept — now use Inter tabular nums)
  static TextStyle get numberHuge => GoogleFonts.instrumentSerif(
    fontSize: 72,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    letterSpacing: -1.5,
    height: 1.0,
  );

  static TextStyle get numberLarge => GoogleFonts.instrumentSerif(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    letterSpacing: -0.5,
  );

  static TextStyle get numberMedium => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.2,
  );

  static TextStyle get numberSmall => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static TextStyle get numberBody => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  // Currency styles — Instrument Serif prefix + Inter value
  static TextStyle get currency => GoogleFonts.instrumentSerif(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
  );

  static TextStyle get currencyLarge => GoogleFonts.instrumentSerif(
    fontSize: 72,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    letterSpacing: -1.5,
    height: 1.0,
  );

  static TextStyle get currencySmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  // Amount input field
  static TextStyle get amountInput => GoogleFonts.instrumentSerif(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    letterSpacing: -0.01,
  );
}
