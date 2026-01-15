import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/settings/view/widgets/appearance_section.dart';
import 'package:quote_vault/features/settings/view/widgets/notification_section.dart';
import 'package:quote_vault/features/settings/view/widgets/settings_footer.dart';
import 'package:quote_vault/features/settings/view/widgets/typography_section.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // HTML uses minimal container constraints (max-w-md mx-auto) for web responsiveness.
    // For mobile (App), we use full width but can respect constraints on larger screens.
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context).withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        // Using `scrolledUnderElevation: 0` helps keep it flat if preferred,
        // but backdrop filter simulation is done via simple opacity here or standard AppBar behavior.
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
              ),
            ),
          ),
        ),
        title: Text(
          'Settings',
          style: AppTextStyles.display.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text(context),
            letterSpacing: -0.015,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Done',
                style: AppTextStyles.display.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
        // HTML has empty left div for balance. AppBar title centering handles this auto-magically.
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480), // Mobile-centric width
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: const [
                AppearanceSection(),
                SizedBox(height: 32),
                TypographySection(),
                SizedBox(height: 32),
                NotificationSection(),
                SizedBox(height: 48),
                SettingsFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
