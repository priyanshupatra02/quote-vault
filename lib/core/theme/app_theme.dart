import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_vault/core/theme/app_colors.dart';

///This class defines light theme and dark theme
///Here we used flex color scheme
class Themes {
  static ThemeData get theme => FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: AppColors.primary,
          primaryContainer: Color(0xFFE0D4FC),
          secondary: AppColors.primary,
          secondaryContainer: Color(0xFFE0D4FC),
        ),
        scaffoldBackground: AppColors.backgroundLight,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        appBarOpacity: 0.95,
        swapColors: false,
        tabBarStyle: FlexTabBarStyle.forBackground,
        fontFamily: GoogleFonts.inter().fontFamily,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: false,
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

  static ThemeData get darkTheme => FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: AppColors.primary,
          primaryContainer: Color(0xFF381E72), // Darker shade for container
          secondary: AppColors.primary,
          secondaryContainer: Color(0xFF381E72),
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
