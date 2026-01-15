import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class DailyInsightBadge extends StatelessWidget {
  const DailyInsightBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light mode: lavender soft bg, charcoal text
    // Dark mode: primary with opacity, primary text
    final bgColor =
        isDark ? AppColors.primary.withOpacity(0.1) : AppColors.lavenderSoft.withOpacity(0.6);
    final borderColor = isDark ? AppColors.primary.withOpacity(0.2) : AppColors.lavenderSoft;
    final iconTextColor = isDark ? AppColors.primary : AppColors.charcoal.withOpacity(0.7);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 36,
          padding: const EdgeInsets.only(left: 12, right: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: iconTextColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'DAILY INSIGHT',
                style: AppTextStyles.dailyInsightBadge.copyWith(
                  color: isDark ? AppColors.primary : AppColors.charcoal.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
