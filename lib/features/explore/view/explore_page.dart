import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/data/model/category_model.dart';
import 'package:quote_vault/features/categories/controller/pod/categories_pod.dart';
import 'package:quote_vault/features/categories/controller/state/categories_states.dart';
import 'package:quote_vault/features/discover/view/widgets/background_layer.dart';
import 'package:quote_vault/features/quotes/controller/pod/quotes_pod.dart';
import 'package:quote_vault/shared/riverpod_ext/asynvalue_easy_when.dart';
import 'package:quote_vault/shared/widget/custom_loaders/app_loader.dart';

@RoutePage()
class ExplorePage extends ConsumerWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundLayer(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  backgroundColor: AppColors.background(context).withOpacity(0.9),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  expandedHeight: 80,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                    title: Text(
                      'Explore',
                      style: AppTextStyles.display.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text(context),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: _buildSearchBar(context, ref),
                  ),
                ),

                // Categories Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: AppTextStyles.display.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text(context),
                            letterSpacing: -0.015,
                          ),
                        ),
                        if (selectedCategory != null)
                          TextButton(
                            onPressed: () {
                              ref.read(selectedCategoryProvider.notifier).state = null;
                              ref.read(quotesProvider.notifier).filterByCategory(null);
                            },
                            child: Text(
                              'Clear Filter',
                              style: AppTextStyles.display.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Categories Grid
                _buildCategoriesGrid(context, ref, categoriesState, selectedCategory),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.text(context).withOpacity(0.1),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search quotes, authors...',
          hintStyle: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary(context),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary(context),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onSubmitted: (query) {
          if (query.isNotEmpty) {
            ref.read(quotesProvider.notifier).search(query);
          }
        },
      ),
    );
  }

  Widget _buildCategoriesGrid(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<CategoriesState> categoriesState,
    int? selectedCategory,
  ) {
    return categoriesState.easyWhen(
      data: (state) {
        if (state is CategoriesLoadingState) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: AppLoader(),
              ),
            ),
          );
        }

        if (state is CategoriesLoadedState) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 4 / 3,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCategoryCard(
                  context,
                  ref,
                  state.categories[index],
                  isSelected: selectedCategory == state.categories[index].id,
                ),
                childCount: state.categories.length,
              ),
            ),
          );
        }

        if (state is CategoriesErrorState) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(state.message, style: const TextStyle(color: Colors.redAccent)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.read(categoriesProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
      loadingWidget: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      errorWidget: (e, _) => SliverToBoxAdapter(
        child: Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent)),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    WidgetRef ref,
    CategoryModel category, {
    bool isSelected = false,
  }) {
    final colors = _getCategoryColors(category.iconName);

    return GestureDetector(
      onTap: () {
        ref.read(selectedCategoryProvider.notifier).state = category.id;
        ref.read(quotesProvider.notifier).filterByCategory(category.id);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Icon
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                _getIconFromName(category.iconName),
                size: 100,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconFromName(category.iconName),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    category.name,
                    style: AppTextStyles.display.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (isSelected)
                    const Text(
                      'Selected',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getCategoryColors(String? iconName) {
    switch (iconName) {
      case 'rocket_launch':
        return [Colors.orange, Colors.deepOrange];
      case 'favorite':
        return [Colors.pink, Colors.red];
      case 'emoji_events':
        return [Colors.amber, Colors.orange];
      case 'psychology':
        return [Colors.purple, Colors.deepPurple];
      case 'sentiment_satisfied':
        return [Colors.yellow.shade700, Colors.amber];
      default:
        return [AppColors.primary, Colors.blue];
    }
  }

  IconData _getIconFromName(String? iconName) {
    switch (iconName) {
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
      default:
        return Icons.category;
    }
  }
}
