import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class QuoteDisplay extends StatelessWidget {
  final String quote;
  final String author;

  const QuoteDisplay({
    super.key,
    required this.quote,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decorative Quote Mark
          Opacity(
            opacity: 0.2,
            child: Text(
              '“',
              style: AppTextStyles.serif.copyWith(
                fontSize: 60,
                color: AppColors.textDark,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Main Quote Text
          Text(
            quote,
            style: AppTextStyles.headline1.copyWith(
              color: AppColors.textDark,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Author Section
          Row(
            children: [
              Container(
                width: 32,
                height: 1,
                color: AppColors.primary.withOpacity(0.5),
              ),
              const SizedBox(width: 12),
              Text(
                author,
                style: AppTextStyles.authorName.copyWith(
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
