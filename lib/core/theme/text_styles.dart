import 'package:flutter/material.dart';

/// Typography system for QuoteVault
///
/// Font Hierarchy:
/// 1. Playfair Display - Headers, premium literary feel
/// 2. Lora - Category titles, maintains "Vault of Wisdom" theme
/// 3. Inter - Supporting text, functional UI elements
class AppTextStyles {
  const AppTextStyles._();

  // Base font families
  // Base font families - kept for utility if needed, but prefer Theme access
  static TextStyle display(BuildContext context) => Theme.of(context).textTheme.bodyMedium!;
  static TextStyle serif(BuildContext context) => Theme.of(context).textTheme.headlineMedium!;
  static TextStyle serifAlt(BuildContext context) => Theme.of(context).textTheme.titleMedium!;

  // ===========================================
  // HEADERS
  // ===========================================

  /// Page title - "Explore", "Discover" (Playfair 32)
  static TextStyle pageTitle(BuildContext context) => Theme.of(context).textTheme.headlineMedium!;

  /// Main Headings - "Keep Going" (Playfair 36)
  static TextStyle headline1(BuildContext context) => Theme.of(context).textTheme.headlineLarge!;

  /// Large Headings - (Playfair 42)
  static TextStyle headline1Large(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall!;

  // ===========================================
  // CATEGORY TITLES
  // ===========================================

  /// Category card titles - "Motivation" (Lora 16)
  static TextStyle categoryTitle(BuildContext context) => Theme.of(context).textTheme.titleMedium!;

  /// Wide category card title (Lora 20)
  static TextStyle categoryTitleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!;

  // ===========================================
  // SUPPORTING TEXT
  // ===========================================

  /// Section headers - "FEATURED AUTHORS" (Inter 11)
  static TextStyle sectionLabel(BuildContext context) => Theme.of(context).textTheme.labelSmall!;

  /// Sub-details - "2.4k Quotes" (Inter 10)
  static TextStyle subDetail(BuildContext context) => Theme.of(context).textTheme.bodySmall!;

  /// Search placeholder and hints (Inter 14)
  static TextStyle searchHint(BuildContext context) => Theme.of(context).textTheme.bodyMedium!;

  // ===========================================
  // AUTHOR NAMES
  // ===========================================

  /// Author names in carousel (Inter 11)
  static TextStyle authorName(BuildContext context) => Theme.of(context).textTheme.labelMedium!;

  /// Author initials in avatars (Playfair 24)
  static TextStyle authorInitials(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!;

  /// Large author name (Inter 14 Bold)
  static TextStyle authorNameLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.1,
          );

  // ===========================================
  // NAVIGATION
  // ===========================================

  /// Bottom nav active label
  static TextStyle navLabelActive(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall!.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w700,
          );

  /// Bottom nav inactive label
  static TextStyle navLabelInactive(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall!.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          );

  static TextStyle bottomNavText(BuildContext context) => navLabelInactive(context);

  // ===========================================
  // GENERAL UI ELEMENTS
  // ===========================================

  static TextStyle buttonText(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          );

  static TextStyle dailyInsightBadge(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!;

  static TextStyle label(BuildContext context) => Theme.of(context).textTheme.labelLarge!;

  static TextStyle body(BuildContext context) => Theme.of(context).textTheme.bodyMedium!;

  /// Link text - "View All"
  static TextStyle linkText(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: 12,
          );
}
