import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class DailyInsightBadge extends StatelessWidget {
  const DailyInsightBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.only(left: 12, right: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999), // Pill shape
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'DAILY INSIGHT',
            style: AppTextStyles.dailyInsightBadge.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
