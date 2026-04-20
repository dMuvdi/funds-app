import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Surfaces
  static const Color paper = Color(0xFFF6F4EE);
  static const Color paper2 = Color(0xFFEFEDE6);
  static const Color card = Color(0xFFFFFFFF);

  // Ink / text
  static const Color ink = Color(0xFF111114);
  static const Color ink2 = Color(0xFF2A2A30);
  static const Color muted = Color(0xFF6B6B74);
  static const Color muted2 = Color(0xFF8E8E98);

  // Dividers
  static const Color line = Color(0x14111114); // rgba(17,17,20,0.08)
  static const Color lineStrong = Color(0x29111114); // rgba(17,17,20,0.16)

  // Accent — electric green
  static const Color accent = Color(0xFF4ADE80);
  static const Color accentInk = Color(0xFF15803D);
  static const Color accentSoft = Color(0xFFDCFCE7);

  // Danger
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerSoft = Color(0xFFFEE2E2);

  // Warning
  static const Color warn = Color(0xFFF59E0B);

  // Category pills
  static const Color fpvBadgeBg = Color(0x0F111114); // ink at 6% opacity
  static const Color fpvBadgeFg = Color(0xFF111114);
  static const Color ficBadgeBg = Color(0xFFDCFCE7);
  static const Color ficBadgeFg = Color(0xFF15803D);

  // Legacy aliases used by existing widgets / theme
  static const Color primary = ink;
  static const Color primaryLight = ink2;
  static const Color background = paper;
  static const Color surface = card;
  static const Color surfaceAlt = paper2;
  static const Color surfaceDark = lineStrong;
  static const Color textPrimary = ink;
  static const Color textSecondary = muted;
  static const Color textTertiary = muted2;
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFFFFFFFF);
  static const Color success = accent;
  static const Color successLight = accentSoft;
  static const Color error = danger;
  static const Color errorLight = dangerSoft;
  static const Color warning = warn;
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDCECFE);
  static const Color overlay = Color(0x800A0A0F);
  static const Color shadowLight = Color(0x0A111114);
  static const Color shadowMedium = Color(0x1F111114);
}
