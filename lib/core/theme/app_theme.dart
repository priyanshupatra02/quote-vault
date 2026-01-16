import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_vault/core/theme/app_colors.dart';

///This class defines light theme and dark theme
///Here we used flex color scheme
class Themes {
  static ThemeData getTheme(Color primaryColor) => FlexThemeData.light(
        colors: FlexSchemeColor(
          primary: primaryColor,
          primaryContainer: Color.alphaBlend(primaryColor.withOpacity(0.2), Colors.white),
          secondary: primaryColor,
          secondaryContainer: Color.alphaBlend(primaryColor.withOpacity(0.2), Colors.white),
        ),
        scaffoldBackground: AppColors.backgroundLight,
        background: AppColors.backgroundLight,
        surface: AppColors.surfaceLight,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 5,
        appBarOpacity: 0.95,
        swapColors: false,
        tabBarStyle: FlexTabBarStyle.forBackground,
        fontFamily: GoogleFonts.inter().fontFamily,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          inputDecoratorRadius: 8,
          defaultRadius: 16.0,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        textTheme: _textTheme,
      );

  static ThemeData getDarkTheme(Color primaryColor) => FlexThemeData.dark(
        colors: FlexSchemeColor(
          primary: primaryColor,
          primaryContainer: Color.alphaBlend(primaryColor.withOpacity(0.4), Colors.black),
          secondary: primaryColor,
          secondaryContainer: Color.alphaBlend(primaryColor.withOpacity(0.4), Colors.black),
        ),
        scaffoldBackground: AppColors.backgroundDark,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,

        surfaceMode: FlexSurfaceMode.custom,
        blendLevel: 0, // Disable blending to keep our custom colors exact
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.90,
        tabBarStyle: FlexTabBarStyle.forBackground,
        fontFamily: GoogleFonts.inter().fontFamily,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 0,
          inputDecoratorRadius: 8,
          defaultRadius: 8.0,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        textTheme: _textTheme,
      );

  // Centralized TextTheme to ensure font hierarchy compliance (Playfair > Lora > Inter)
  static TextTheme get _textTheme => TextTheme(
        // Page Titles (Playfair Display)
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        // Category Titles (Lora)
        titleMedium: GoogleFonts.lora(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        // Section Headers & Labels (Inter)
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        // Default Body (Inter)
        bodyMedium: GoogleFonts.inter(),

        // NEW: Refactor Mappings
        // headline1 -> headlineLarge (Playfair 36)
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 36,
          fontWeight: FontWeight.w500,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        // headline1Large -> displaySmall (Playfair 42)
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 42,
        ),
        // categoryTitleLarge -> titleLarge (Lora 20)
        titleLarge: GoogleFonts.lora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        // subDetail -> bodySmall (Inter 10)
        bodySmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        // label -> labelLarge (Inter 12)
        labelLarge: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        // authorInitials -> headlineSmall (Playfair 24)
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 24,
        ),
        // authorName -> labelMedium (Inter 11)
        labelMedium: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      );
}
