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
      );
}
