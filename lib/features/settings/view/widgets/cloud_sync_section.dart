import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/settings/controller/sync_settings_provider.dart';
import 'package:quote_vault/shared/widget/custom_loaders/app_loader.dart';

class CloudSyncSection extends ConsumerWidget {
  const CloudSyncSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return syncState.when(
      data: (isSynced) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.cloud_sync,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Cloud Sync',
                              style: AppTextStyles.display(context).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isSynced
                              ? 'Your quotes are backed up across all devices automatically.'
                              : 'Cloud sync is paused. New quotes will only be saved locally.',
                          style: AppTextStyles.body(context).copyWith(
                            fontSize: 14,
                            color: AppColors.textSecondary(context),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isSynced)
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF059669), // Emerald 600
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Last synced: Just now',
                                style: AppTextStyles.label(context).copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Switch(
                    value: isSynced,
                    onChanged: (value) {
                      ref.read(syncSettingsProvider.notifier).updateSync(value);
                    },
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF22C55E), // Green 500
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: AppLoader()),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
