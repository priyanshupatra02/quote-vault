import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/services/notification_service.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/settings/view/widgets/appearance_section.dart';
import 'package:quote_vault/features/settings/view/widgets/cloud_sync_section.dart';
import 'package:quote_vault/features/settings/view/widgets/notification_section.dart';
import 'package:quote_vault/features/settings/view/widgets/profile_section.dart';
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
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textSecondary(context),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
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
                if (kDebugMode) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Text(
                      'DEBUG OPTIONS',
                      style: AppTextStyles.label.copyWith(
                        color: Colors.orange,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.3),
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.notifications_active,
                          color: Colors.orange,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        'Test Daily Quote Notification',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.text(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Send a test push notification',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textSecondary(context),
                          fontSize: 12,
                        ),
                      ),
                      trailing: Icon(
                        Icons.send,
                        color: Colors.orange.withOpacity(0.7),
                        size: 20,
                      ),
                      onTap: () async {
                        final notificationService = ref.read(notificationServiceProvider);
                        await notificationService.initialize();
                        await notificationService.requestPermissions();
                        await notificationService.showTestNotification(
                          title: '✨ Daily Quote',
                          body:
                              '"The only way to do great work is to love what you do." — Steve Jobs',
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Test notification sent! 🔔'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

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
