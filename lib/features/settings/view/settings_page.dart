import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/constants/app_strings.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/auth/controller/auth_controller.dart';
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
          AppStrings.profileTitle,
          style: AppTextStyles.pageTitle(context).copyWith(
            fontSize: 20,
            color: AppColors.text(context),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: GestureDetector(
                onTap: () => _showUpdateNameDialog(context, ref),
                child: Text(
                  AppStrings.editButton,
                  style: AppTextStyles.display(context).copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
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
                    AppStrings.headsUpSection,
                    style: AppTextStyles.sectionLabel(context).copyWith(
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

                // Debug Section
                const SettingsDebugSection(),

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
                        AppStrings.logOutButton,
                        style: AppTextStyles.display(context).copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFFF3B30), // iOS Red
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'QuoteVault v2.4.0 (Build 120)',
                      style: AppTextStyles.label(context).copyWith(
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

  void _showUpdateNameDialog(BuildContext context, WidgetRef ref) {
    final user = ref.read(authControllerProvider).value;
    // Get current name same logic as ProfileSection to pre-fill
    final email = user?.email ?? '';
    final metadata = user?.userMetadata;
    final currentName = metadata?['full_name'] ??
        metadata?['name'] ??
        (email.isNotEmpty
            ? email.split('@')[0].split('.').map((e) => e.capitalize()).join(' ')
            : '');

    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Update Name',
          style: AppTextStyles.display(context).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text(context),
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Display Name',
            hintText: 'Enter your name',
            labelStyle: TextStyle(color: AppColors.textSecondary(context)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (controller.text.isNotEmpty) {
                ref.read(authControllerProvider.notifier).updateName(controller.text);
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
