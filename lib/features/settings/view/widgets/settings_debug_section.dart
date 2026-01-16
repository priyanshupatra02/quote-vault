import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/services/notification_service.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class SettingsDebugSection extends ConsumerWidget {
  const SettingsDebugSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(
            'Advanced',
            style: AppTextStyles.sectionLabel(context).copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.textSecondary(context).withOpacity(0.2),
            ),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            title: Text(
              'Preview Daily Quote',
              style: AppTextStyles.label(context).copyWith(
                color: AppColors.text(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Send yourself a test notification to see how it looks',
              style: AppTextStyles.label(context).copyWith(
                color: AppColors.textSecondary(context),
                fontSize: 12,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary(context),
              size: 20,
            ),
            onTap: () async {
              final notificationService = ref.read(notificationServiceProvider);
              await notificationService.initialize();
              await notificationService.requestPermissions();
              await notificationService.showTestNotification(
                title: '✨ Daily Quote',
                body: '"The only way to do great work is to love what you do." — Steve Jobs',
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
    );
  }
}
