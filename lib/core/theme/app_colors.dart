import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF5417cf);

  // Light mode colors (from HTML design)
  static const Color cream = Color(0xFFFDFCF8); // Background
  static const Color charcoal = Color(0xFF1A1C1E); // Text
  static const Color slateMuted = Color(0xFF64748b); // Secondary text
  static const Color goldMuted = Color(0xFFA68E5D); // Author text
  static const Color lavenderSoft = Color(0xFFE9E5F3); // Badge background

  // Legacy light colors (mapped to new design)
  static const Color backgroundLight = cream;
  static const Color surfaceLight = Color(0xFFffffff);
  static const Color textLight = charcoal;
  static const Color textSecondaryLight = slateMuted;

  // Dark mode colors as per design
  static const Color backgroundDark = Color(0xFF161121);
  static const Color surfaceDark = Color(0xFF1f1a2e);
  static const Color textDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFA69DB8);

  // Gradients
  static const RadialGradient premiumGradient = RadialGradient(
    center: Alignment(0, -1), // Top center
    radius: 1.0,
    colors: [
      Color.fromRGBO(84, 23, 207, 0.25), // primary with 0.25 opacity
      Color.fromRGBO(22, 17, 33, 0), // backgroundDark with 0 opacity
    ],
    stops: [0.0, 0.7],
  );

  // Helper to get correct color based on brightness
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? backgroundDark : backgroundLight;

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? surfaceDark : surfaceLight;

  static Color text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textDark : textLight;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textSecondaryDark : textSecondaryLight;

  // New helper for author text (gold in light, secondary in dark)
  static Color authorText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textSecondaryDark : goldMuted;

  // Helper for badge background
  static Color badgeBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? primary.withOpacity(0.1)
          : lavenderSoft.withOpacity(0.6);
}
