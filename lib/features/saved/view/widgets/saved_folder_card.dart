import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class SavedFolderCard extends StatelessWidget {
  final String title;
  final int count;

  const SavedFolderCard({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1), // bg-primary/10
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.folder,
                color: AppColors.primary,
                size: 28, // text-3xl approx
              ),
              Icon(
                Icons.more_horiz,
                color: AppColors.text(context).withOpacity(0.4),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.display(context).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count quotes',
            style: AppTextStyles.display(context).copyWith(
              fontSize: 12,
              color: AppColors.text(context).withOpacity(0.5), // gray-400
            ),
          ),
        ],
      ),
    );
  }
}
