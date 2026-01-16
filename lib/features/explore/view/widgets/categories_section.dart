import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/constants/app_strings.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/data/model/category_model.dart';
import 'package:quote_vault/features/categories/controller/pod/categories_pod.dart';
import 'package:quote_vault/features/categories/controller/state/categories_states.dart';
import 'package:quote_vault/features/explore/view/widgets/category_card.dart';
import 'package:quote_vault/features/quotes/controller/pod/quotes_pod.dart';
import 'package:quote_vault/shared/riverpod_ext/asynvalue_easy_when.dart';
import 'package:quote_vault/shared/widget/custom_loaders/app_loader.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              AppStrings.categoriesSectionTitle,
              style: AppTextStyles.sectionLabel(context).copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Categories Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: categoriesState.easyWhen(
              data: (state) {
                if (state is CategoriesLoadedState) {
                  return CategoriesGrid(categories: state.categories);
                }
                if (state is CategoriesLoadingState) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: AppLoader(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              loadingWidget: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: AppLoader(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesGrid extends ConsumerWidget {
  const CategoriesGrid({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(AppStrings.noCategories),
        ),
      );
    }

    // Build rows dynamically based on actual category count
    final List<Widget> rows = [];

    // Create 2-column rows
    for (int i = 0; i < categories.length; i += 2) {
      if (i + 1 < categories.length) {
        // Two cards in a row
        rows.add(
          Row(
            children: [
              Expanded(
                child: CategoryCard(
                  category: categories[i],
                  style: _getStyleForCategory(context, categories[i]),
                  onTap: () => _selectCategory(context, ref, categories[i]),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CategoryCard(
                  category: categories[i + 1],
                  style: _getStyleForCategory(context, categories[i + 1]),
                  onTap: () => _selectCategory(context, ref, categories[i + 1]),
                ),
              ),
            ],
          ),
        );
      } else {
        // Last single card - make it wide
        rows.add(
          WideCategoryCard(
            category: categories[i],
            style: _getStyleForCategory(context, categories[i]),
            onTap: () => _selectCategory(context, ref, categories[i]),
          ),
        );
      }

      if (i + 2 < categories.length) {
        rows.add(const SizedBox(height: 16));
      }
    }

    return Column(children: rows);
  }

  void _selectCategory(BuildContext context, WidgetRef ref, CategoryModel? category) {
    if (category == null) return;
    ref.read(selectedCategoryProvider.notifier).state = category.id;
    ref.read(quotesProvider.notifier).filterByCategory(category.id);
    // Navigate to Discover page to show filtered results
    context.router.navigate(const DiscoverRoute());
  }

  /// Get style for category based on its name or iconName from API
  CategoryStyle _getStyleForCategory(BuildContext context, CategoryModel category) {
    final name = category.name.toLowerCase();
    final iconName = category.iconName?.toLowerCase() ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Base transparency for dark mode
    final darkBg = Colors.white.withOpacity(0.05);
    final darkIconBg = Colors.white.withOpacity(0.05);

    // Define color palettes for known categories
    if (name.contains('motivation') || iconName.contains('bolt') || iconName.contains('rocket')) {
      return CategoryStyle(
        bgColor: isDark ? darkBg : const Color(0xFFF3E8FF),
        iconBgColor: isDark ? darkIconBg : Colors.white.withOpacity(0.6),
        iconColor:
            isDark ? const Color(0xFFD8B4FE) : const Color(0xFF7C3AED), // Lighter purple in dark
        icon: Icons.bolt,
      );
    } else if (name.contains('love') ||
        iconName.contains('favorite') ||
        iconName.contains('heart')) {
      return CategoryStyle(
        bgColor: isDark ? darkBg : const Color(0xFFFFE4E6),
        iconBgColor: isDark ? darkIconBg : Colors.white.withOpacity(0.6),
        iconColor:
            isDark ? const Color(0xFFFB7185) : const Color(0xFFBE123C), // Lighter rose in dark
        icon: Icons.favorite,
      );
    } else if (name.contains('success') ||
        iconName.contains('trending') ||
        iconName.contains('trophy')) {
      return CategoryStyle(
        bgColor: isDark ? darkBg : const Color(0xFFDCFCE7),
        iconBgColor: isDark ? darkIconBg : Colors.white.withOpacity(0.6),
        iconColor: isDark ? const Color(0xFF34D399) : const Color(0xFF047857), // Lighter emerald
        icon: Icons.trending_up,
      );
    } else if (name.contains('wisdom') ||
        iconName.contains('lightbulb') ||
        iconName.contains('psychology')) {
      return CategoryStyle(
        bgColor: isDark ? darkBg : const Color(0xFFFEF3C7),
        iconBgColor: isDark ? darkIconBg : Colors.white.withOpacity(0.6),
        iconColor: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309), // Lighter amber
        icon: Icons.lightbulb,
      );
    } else if (name.contains('humor') || name.contains('funny') || iconName.contains('sentiment')) {
      return CategoryStyle(
        bgColor: isDark ? darkBg : const Color(0xFFFCE7F3),
        iconBgColor: isDark ? darkIconBg : Colors.white.withOpacity(0.6),
        iconColor: isDark ? const Color(0xFFF472B6) : const Color(0xFFBE185D), // Lighter pink
        icon: Icons.sentiment_very_satisfied,
      );
    } else if (name.contains('life') || iconName.contains('nature')) {
      return CategoryStyle(
        bgColor: isDark ? darkBg : const Color(0xFFE0F2FE),
        iconBgColor: isDark ? darkIconBg : Colors.white.withOpacity(0.6),
        iconColor: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0369A1), // Lighter sky
        icon: Icons.spa,
      );
    } else if (name.contains('friendship') || iconName.contains('people')) {
      return CategoryStyle(
        bgColor: isDark ? darkBg : const Color(0xFFFEF9C3),
        iconBgColor: isDark ? darkIconBg : Colors.white.withOpacity(0.6),
        iconColor: isDark ? const Color(0xFFFACC15) : const Color(0xFFA16207), // Lighter yellow
        icon: Icons.people,
      );
    } else if (name.contains('happiness') || name.contains('joy')) {
      return CategoryStyle(
        bgColor: isDark ? darkBg : const Color(0xFFFFFBEB),
        iconBgColor: isDark ? darkIconBg : Colors.white.withOpacity(0.6),
        iconColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706), // Lighter orange
        icon: Icons.emoji_emotions,
      );
    }

    // Default style for unknown categories
    return CategoryStyle(
      bgColor: isDark ? darkBg : const Color(0xFFF1F5F9),
      iconBgColor: isDark ? darkIconBg : Colors.white.withOpacity(0.6),
      iconColor: AppColors.primary,
      icon: _getIconFromName(category.iconName),
    );
  }

  IconData _getIconFromName(String? iconName) {
    switch (iconName?.toLowerCase()) {
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'favorite':
        return Icons.favorite;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'psychology':
        return Icons.psychology;
      case 'sentiment_satisfied':
        return Icons.sentiment_satisfied;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'bolt':
        return Icons.bolt;
      case 'trending_up':
        return Icons.trending_up;
      default:
        return Icons.format_quote;
    }
  }
}
