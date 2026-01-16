import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system for QuoteVault
///
/// Font Hierarchy:
/// 1. Playfair Display - Headers, premium literary feel
/// 2. Lora - Category titles, maintains "Vault of Wisdom" theme
/// 3. Inter - Supporting text, functional UI elements
class AppTextStyles {
  const AppTextStyles._();

  // Base font families
  static TextStyle get display => GoogleFonts.inter();
  static TextStyle get serif => GoogleFonts.playfairDisplay();
  static TextStyle get serifAlt => GoogleFonts.lora();

  // ===========================================
  // HEADERS (Playfair Display - Bold/700)
  // ===========================================

  /// Page title - "Explore", "Discover", etc.
  static TextStyle get pageTitle => serif.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  static TextStyle get headline1 => serif.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get headline1Large => headline1.copyWith(
        fontSize: 42,
      );

  // ===========================================
  // CATEGORY TITLES (Lora/Playfair - Bold/600-700)
  // ===========================================

  /// Category card titles - "Motivation", "Love", etc.
  static TextStyle get categoryTitle => serifAlt.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  /// Wide category card title
  static TextStyle get categoryTitleLarge => serifAlt.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  // ===========================================
  // SUPPORTING TEXT (Inter - Medium 500 / Regular 400)
  // ===========================================

  /// Section headers - "FEATURED AUTHORS", "BROWSE BY CATEGORY"
  static TextStyle get sectionLabel => display.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      );

  /// Sub-details - "2.4k Quotes", "Lighten your day"
  static TextStyle get subDetail => display.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );

  /// Search placeholder and hints
  static TextStyle get searchHint => display.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  // ===========================================
  // AUTHOR NAMES (Inter - Semi-Bold 600)
  // ===========================================

  /// Author names in carousel
  static TextStyle get authorName => display.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  /// Author initials in avatars
  static TextStyle get authorInitials => serif.copyWith(
        fontSize: 24,
      );

  /// Large author name (for author detail pages)
  static TextStyle get authorNameLarge => display.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.1,
      );

  // ===========================================
  // NAVIGATION (Inter - Bold 700 for active)
  // ===========================================

  /// Bottom nav active label
  static TextStyle get navLabelActive => display.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w700,
      );

  /// Bottom nav inactive label
  static TextStyle get navLabelInactive => display.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bottomNavText => navLabelInactive;

  // ===========================================
  // GENERAL UI ELEMENTS
  // ===========================================

  static TextStyle get buttonText => display.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
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

  /// Link text - "View All"
  static TextStyle get linkText => display.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );
}
