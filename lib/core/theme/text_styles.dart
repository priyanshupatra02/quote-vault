import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get display => GoogleFonts.inter();
  static TextStyle get serif => GoogleFonts.playfairDisplay();

  // Headings
  static TextStyle get headline1 => serif.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: -0.5, // tight tracking
      );

  static TextStyle get headline1Large => headline1.copyWith(
        fontSize: 42,
      );

  static TextStyle get authorName => display.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.1, // 0.15em ~ 14 * 0.15
      );

  static TextStyle get buttonText => display.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bottomNavText => display.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get dailyInsightBadge => display.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get label => display.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get body => display.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
}
