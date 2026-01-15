import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class SavedQuoteCard extends StatelessWidget {
  final String text;
  final String author;
  final bool isFavorite;
  final String? tag;
  final bool isLongText;

  const SavedQuoteCard({
    super.key,
    required this.text,
    required this.author,
    this.isFavorite = false,
    this.tag,
    this.isLongText = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12), // rounded-xl
        border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Icon)
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: isFavorite ? Colors.redAccent : AppColors.textSecondary(context), // gray-600
            ),
          ),
          const SizedBox(height: 8),

          // Content
          Stack(
            children: [
              Text(
                '"$text"',
                style: AppTextStyles.display.copyWith(
                  fontSize: 14, // text-sm
                  fontWeight: FontWeight.w500,
                  color: AppColors.text(context).withOpacity(0.9), // gray-100
                  height: 1.6, // leading-relaxed
                ),
              ),
              if (isLongText)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.surface(context),
                          AppColors.surface(context).withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Author
          Text(
            '— $author',
            style: AppTextStyles.display.copyWith(
              fontSize: 12, // text-xs
              fontWeight: FontWeight.w500,
              color: AppColors.text(context).withOpacity(0.5), // gray-500
            ),
          ),

          // Optional Tag
          if (tag != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tag!,
                style: AppTextStyles.display.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text(context).withOpacity(0.6), // gray-400
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
