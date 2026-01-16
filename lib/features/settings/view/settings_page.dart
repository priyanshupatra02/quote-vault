import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/settings/view/widgets/appearance_section.dart';
import 'package:quote_vault/features/settings/view/widgets/cloud_sync_section.dart';
import 'package:quote_vault/features/settings/view/widgets/notification_section.dart';
import 'package:quote_vault/features/settings/view/widgets/profile_section.dart';
import 'package:quote_vault/features/settings/view/widgets/settings_debug_section.dart';
import 'package:quote_vault/features/settings/view/widgets/stats_grid.dart';
import 'package:quote_vault/features/settings/view/widgets/typography_section.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          'Profile',
          style: AppTextStyles.pageTitle.copyWith(
            fontSize: 20,
            color: AppColors.text(context),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Edit',
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
              children: [
                // Profile Section
                const ProfileSection(),
                const SizedBox(height: 32),

                // Stats Grid
                const StatsGrid(),
                const SizedBox(height: 24),

                // Cloud Sync
                const CloudSyncSection(),
                const SizedBox(height: 32),

                // Preferences Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(
                    'HEADS UP',
                    style: AppTextStyles.sectionLabel.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Existing Sections
                const AppearanceSection(),
                const SizedBox(height: 32),
                const TypographySection(),
                const SizedBox(height: 32),
                const NotificationSection(),
                const SizedBox(height: 32),

                // Debug Section (only in debug mode)
                if (kDebugMode) const SettingsDebugSection(),

                // Log Out & Footer
                Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final supabase = Supabase.instance.client;
                        await supabase.auth.signOut();
                        if (context.mounted) {
                          context.router.replaceAll([const LoginRoute()]);
                        }
                      },
                      child: Text(
                        'Log Out',
                        style: AppTextStyles.display.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFFF3B30), // iOS Red
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'QuoteVault v2.4.0 (Build 120)',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary(context),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
