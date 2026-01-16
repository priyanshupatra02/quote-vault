import 'package:flutter/material.dart';
import 'package:quote_vault/core/constants/app_strings.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/data/model/category_model.dart';

/// Style configuration for category cards
class CategoryStyle {
  const CategoryStyle({
    required this.icon,
    required this.bgColor,
    required this.iconBgColor,
    required this.iconColor,
  });

  final IconData icon;
  final Color bgColor;
  final Color iconBgColor;
  final Color iconColor;
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.style,
    required this.onTap,
  });

  final CategoryModel? category;
  final CategoryStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 144,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: style.bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: style.iconBgColor,
              ),
              child: Icon(
                style.icon,
                color: style.iconColor,
                size: 20,
              ),
            ),

            // Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category?.name ?? AppStrings.categoryDefault,
                  style: AppTextStyles.categoryTitle(context).copyWith(
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.exploreQuotes,
                  style: AppTextStyles.subDetail(context).copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WideCategoryCard extends StatelessWidget {
  const WideCategoryCard({
    super.key,
    required this.category,
    required this.style,
    required this.onTap,
  });

  final CategoryModel category;
  final CategoryStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 112,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: style.bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left content
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: style.iconBgColor,
                  ),
                  child: Icon(
                    style.icon,
                    color: style.iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      style: AppTextStyles.categoryTitleLarge(context).copyWith(
                        color: AppColors.text(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // You might want to add subtitle here if needed, or keep it minimal
                  ],
                ),
              ],
            ),
            // Right Arrow
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
