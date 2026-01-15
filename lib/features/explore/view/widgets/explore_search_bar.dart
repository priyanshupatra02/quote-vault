import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class ExploreSearchBar extends StatelessWidget {
  const ExploreSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12), // rounded-xl
        border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.search,
            color: AppColors.textSecondary(context), // slate-400 / #a69db8
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search quotes, authors, or topics...',
              style: AppTextStyles.display.copyWith(
                color: AppColors.textSecondary(context).withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.mic,
            color: AppColors.textSecondary(context),
            size: 24,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
