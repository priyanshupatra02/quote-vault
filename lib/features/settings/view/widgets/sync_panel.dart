import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class SyncPanel extends StatefulWidget {
  const SyncPanel({super.key});

  @override
  State<SyncPanel> createState() => _SyncPanelState();
}

class _SyncPanelState extends State<SyncPanel> {
  bool isSynced = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color:
                isDark ? const Color(0xFF443C53).withOpacity(0.5) : Colors.black.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cloud_sync, color: AppColors.primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Cloud Sync',
                      style: AppTextStyles.display.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text(context),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Wrap text to avoid overflow
                Text(
                  'Your quotes are backed up across all devices automatically.',
                  style: AppTextStyles.display.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.teal.shade500, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Last synced: Just now',
                      style: AppTextStyles.display.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal.shade500, // emerald-400
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Custom Switch
          GestureDetector(
            onTap: () => setState(() => isSynced = !isSynced),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 51,
              height: 31,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: isSynced
                    ? AppColors.primary
                    : (isDark ? const Color(0xFF2E2938) : Colors.grey.shade300),
              ),
              alignment: isSynced ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 27,
                height: 27,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
