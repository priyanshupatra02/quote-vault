import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

enum CollectionCardType {
  gradient,
  image,
  solid,
}

class CollectionCard extends StatelessWidget {
  final String title;
  final String count;
  final CollectionCardType type;
  final List<Color>? gradientColors;
  final String? imageUrl;
  final Color? solidColor;
  final Widget? contentPreview;

  const CollectionCard({
    super.key,
    required this.title,
    required this.count,
    this.type = CollectionCardType.gradient,
    this.gradientColors,
    this.imageUrl,
    this.solidColor,
    this.contentPreview,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: solidColor ?? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          if (!isDark && type != CollectionCardType.solid)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Layer
          if (type == CollectionCardType.gradient && gradientColors != null)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors!.map((c) => c.withOpacity(0.15)).toList(),
                ),
              ),
            ),

          if (type == CollectionCardType.image && imageUrl != null)
            Positioned.fill(
              child: Opacity(
                opacity: isDark ? 0.3 : 0.2, // Low opacity for background feel
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey.withOpacity(0.2)),
                ),
              ),
            ),

          // Content Layer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Action (Three dots)
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.more_horiz,
                    color: _getIconColor(isDark),
                    size: 20,
                  ),
                ),

                // Center Preview
                Expanded(
                  child: Center(
                    child: contentPreview ?? const SizedBox(),
                  ),
                ),

                // Bottom Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.display.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getTextColor(context, isDark),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count Quotes',
                      style: AppTextStyles.display.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getSubTextColor(context, isDark),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getIconColor(bool isDark) {
    if (type == CollectionCardType.solid) {
      // Assuming solid cards might be bright/dark, adapting logic simply for now
      // HTML example showing black/40 for yellow card
      if (solidColor == const Color(0xFFffeb3b) || solidColor == const Color(0xFFfdd835)) {
        return Colors.black.withOpacity(0.4);
      }
      return Colors.white.withOpacity(0.6);
    }
    return isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.3);
  }

  Color _getTextColor(BuildContext context, bool isDark) {
    if (type == CollectionCardType.solid) {
      // Assuming yellow/bright solid backgrounds
      if (solidColor == const Color(0xFFffeb3b) || solidColor == const Color(0xFFfdd835)) {
        return Colors.black;
      }
      return Colors.white;
    }
    return AppColors.text(context);
  }

  Color _getSubTextColor(BuildContext context, bool isDark) {
    if (type == CollectionCardType.solid) {
      if (solidColor == const Color(0xFFffeb3b) || solidColor == const Color(0xFFfdd835)) {
        return Colors.black.withOpacity(0.6);
      }
      return Colors.white.withOpacity(0.7);
    }
    return AppColors.textSecondary(context);
  }
}
