import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class SavedStats extends StatelessWidget {
  const SavedStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cloud Synced Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'CLOUD SYNCED',
                style: AppTextStyles.display(context).copyWith(
                  fontSize: 12, // text-xs
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: 0.5, // tracking-wide
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Stats Summary
        Text(
          '1,240',
          style: AppTextStyles.display(context).copyWith(
            fontSize: 36, // text-4xl
            fontWeight: FontWeight.bold,
            color: AppColors.text(context),
            letterSpacing: -0.025, // tracking-tight
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Quotes Saved',
          style: AppTextStyles.display(context).copyWith(
            fontSize: 14, // text-sm
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary(context), // slate-400 / #94a3b8
          ),
        ),
      ],
    );
  }
}
