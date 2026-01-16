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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.text(context);
    final authorColor = AppColors.authorText(context);

    // Author line color: gold-muted in light, primary in dark
    final lineColor =
        isDark ? AppColors.primary.withOpacity(0.5) : AppColors.goldMuted.withOpacity(0.4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decorative Quote Mark (larger, 0.1 opacity per HTML)
          Opacity(
            opacity: 0.1,
            child: Text(
              '"',
              style: AppTextStyles.serif.copyWith(
                fontSize: 96, // text-8xl = 96px
                color: textColor,
                height: 0.8,
              ),
            ),
          ),

          // Main Quote Text (38px serif font matching HTML)
          Text(
            quote,
            style: AppTextStyles.serif.copyWith(
              fontSize: 38,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.9),
              height: 1.25,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 40),

          // Author Section (gold in light mode)
          Row(
            children: [
              Container(
                width: 24,
                height: 1,
                color: lineColor,
              ),
              const SizedBox(width: 16),
              Text(
                author,
                style: AppTextStyles.sectionLabel.copyWith(
                  color: authorColor,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
