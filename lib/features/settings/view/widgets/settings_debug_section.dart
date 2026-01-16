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
            'DEBUG OPTIONS',
            style: AppTextStyles.sectionLabel.copyWith(
              color: Colors.orange,
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
