import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/data/model/category_model.dart';
import 'package:quote_vault/features/categories/controller/pod/categories_pod.dart';
import 'package:quote_vault/features/categories/controller/state/categories_states.dart';
import 'package:quote_vault/features/quotes/controller/pod/quotes_pod.dart';
import 'package:quote_vault/shared/riverpod_ext/asynvalue_easy_when.dart';
import 'package:quote_vault/shared/widget/custom_loaders/app_loader.dart';

@RoutePage()
class ExplorePage extends ConsumerWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sticky Header with Title + Search
            const _ExploreHeader(),

            // Featured Authors Section
            const _FeaturedAuthorsSection(),

            // Categories Section
            const _CategoriesSection(),

            // Bottom padding for navbar
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

/// Sticky header with title and search bar
class _ExploreHeader extends StatelessWidget {
  const _ExploreHeader();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white.withOpacity(0.95),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Explore',
              style: AppTextStyles.pageTitle.copyWith(
                color: const Color(0xFF0F172A),
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            const _SearchBar(),
          ],
        ),
      ),
    );
  }
}

/// Modern search bar with suggestions
class _SearchBar extends ConsumerStatefulWidget {
  const _SearchBar();

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  // Predefined search suggestions
  static const List<String> _allSuggestions = [
    'Love',
    'Life',
    'Motivation',
    'Success',
    'Happiness',
    'Wisdom',
    'Friendship',
    'Courage',
    'Hope',
    'Dreams',
    'Marcus Aurelius',
    'Maya Angelou',
    'Albert Einstein',
    'Rumi',
    'Oscar Wilde',
    'Buddha',
    'Confucius',
    'Lao Tzu',
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && _controller.text.isNotEmpty;
    });
  }

  void _onTextChange() {
    final query = _controller.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSuggestions = [];
        _showSuggestions = false;
      } else {
        _filteredSuggestions =
            _allSuggestions.where((s) => s.toLowerCase().contains(query)).take(5).toList();
        _showSuggestions = _focusNode.hasFocus && _filteredSuggestions.isNotEmpty;
      }
    });
  }

  void _onSuggestionTap(String suggestion) {
    _controller.text = suggestion;
    _showSuggestions = false;
    _focusNode.unfocus();
    ref.read(quotesProvider.notifier).search(suggestion);
    context.router.navigate(const DiscoverRoute());
  }

  void _onSubmit(String query) {
    if (query.isNotEmpty) {
      _showSuggestions = false;
      _focusNode.unfocus();
      ref.read(quotesProvider.notifier).search(query);
      context.router.navigate(const DiscoverRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Search keywords or authors...',
              hintStyle: AppTextStyles.searchHint.copyWith(
                color: Colors.grey.shade400,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade400,
              ),
              // suffixIcon: Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     if (_controller.text.isNotEmpty)
              //       GestureDetector(
              //         onTap: () {
              //           _controller.clear();
              //           setState(() {
              //             _showSuggestions = false;
              //           });
              //         },
              //         child: Icon(
              //           Icons.close,
              //           color: Colors.grey.shade400,
              //           size: 20,
              //         ),
              //       ),
              //     const SizedBox(width: 8),
              //     Container(
              //       height: 20,
              //       width: 1,
              //       color: Colors.grey.shade200,
              //     ),
              //     const SizedBox(width: 12),
              //     Icon(
              //       Icons.tune,
              //       color: Colors.grey.shade400,
              //       size: 20,
              //     ),
              //     const SizedBox(width: 16),
              //   ],
              // ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onSubmitted: _onSubmit,
          ),
        ),

        // Suggestions Dropdown
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _filteredSuggestions.map((suggestion) {
                  final isAuthor = suggestion.contains(' ');
                  return InkWell(
                    onTap: () => _onSuggestionTap(suggestion),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            isAuthor ? Icons.person_outline : Icons.tag,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              suggestion,
                              style: AppTextStyles.body.copyWith(
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.north_west,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

/// Featured Authors horizontal section
class _FeaturedAuthorsSection extends ConsumerWidget {
  const _FeaturedAuthorsSection();

  static const List<Map<String, String>> _authors = [
    {'initials': 'MA', 'name': 'Marcus\nAurelius', 'searchName': 'Marcus Aurelius'},
    {'initials': 'My', 'name': 'Maya\nAngelou', 'searchName': 'Maya Angelou'},
    {'initials': 'AE', 'name': 'Albert\nEinstein', 'searchName': 'Albert Einstein'},
    {'initials': 'Ru', 'name': 'Rumi', 'searchName': 'Rumi'},
    {'initials': 'OS', 'name': 'Oscar\nWilde', 'searchName': 'Oscar Wilde'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FEATURED AUTHORS',
                  style: AppTextStyles.sectionLabel.copyWith(
                    color: AppColors.kGrey500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Show all authors - for now, show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All authors coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View All',
                    style: AppTextStyles.linkText.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Authors list
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _authors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                final author = _authors[index];
                return _AuthorAvatar(
                  initials: author['initials']!,
                  name: author['name']!,
                  onTap: () {
                    // Search for quotes by this author
                    ref.read(quotesProvider.notifier).search(author['searchName']!);
                    // Navigate to Discover page
                    context.router.navigate(const DiscoverRoute());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual author avatar widget
class _AuthorAvatar extends StatelessWidget {
  const _AuthorAvatar({
    required this.initials,
    required this.name,
    this.onTap,
  });

  final String initials;
  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Avatar circle
          Container(
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade50),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: AppTextStyles.authorInitials.copyWith(
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Name
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppTextStyles.authorName.copyWith(
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

/// Categories grid section
class _CategoriesSection extends ConsumerWidget {
  const _CategoriesSection();

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
              'BROWSE BY CATEGORY',
              style: AppTextStyles.sectionLabel.copyWith(
                color: Colors.grey.shade400,
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
                  return _CategoriesGrid(categories: state.categories);
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

/// Categories grid widget - uses actual API data
class _CategoriesGrid extends ConsumerWidget {
  const _CategoriesGrid({required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No categories available'),
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
                child: _CategoryCard(
                  category: categories[i],
                  style: _getStyleForCategory(categories[i]),
                  onTap: () => _selectCategory(context, ref, categories[i]),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _CategoryCard(
                  category: categories[i + 1],
                  style: _getStyleForCategory(categories[i + 1]),
                  onTap: () => _selectCategory(context, ref, categories[i + 1]),
                ),
              ),
            ],
          ),
        );
      } else {
        // Last single card - make it wide
        rows.add(
          _WideCategoryCard(
            category: categories[i],
            style: _getStyleForCategory(categories[i]),
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
  _CategoryStyle _getStyleForCategory(CategoryModel category) {
    final name = category.name.toLowerCase();
    final iconName = category.iconName?.toLowerCase() ?? '';

    // Define color palettes for known categories
    if (name.contains('motivation') || iconName.contains('bolt') || iconName.contains('rocket')) {
      return _CategoryStyle(
        bgColor: const Color(0xFFF3E8FF),
        iconBgColor: Colors.white.withOpacity(0.6),
        iconColor: const Color(0xFF7C3AED),
        icon: Icons.bolt,
      );
    } else if (name.contains('love') ||
        iconName.contains('favorite') ||
        iconName.contains('heart')) {
      return _CategoryStyle(
        bgColor: const Color(0xFFFFE4E6),
        iconBgColor: Colors.white.withOpacity(0.6),
        iconColor: const Color(0xFFBE123C),
        icon: Icons.favorite,
      );
    } else if (name.contains('success') ||
        iconName.contains('trending') ||
        iconName.contains('trophy')) {
      return _CategoryStyle(
        bgColor: const Color(0xFFDCFCE7),
        iconBgColor: Colors.white.withOpacity(0.6),
        iconColor: const Color(0xFF047857),
        icon: Icons.trending_up,
      );
    } else if (name.contains('wisdom') ||
        iconName.contains('lightbulb') ||
        iconName.contains('psychology')) {
      return _CategoryStyle(
        bgColor: const Color(0xFFFEF3C7),
        iconBgColor: Colors.white.withOpacity(0.6),
        iconColor: const Color(0xFFB45309),
        icon: Icons.lightbulb,
      );
    } else if (name.contains('humor') || name.contains('funny') || iconName.contains('sentiment')) {
      return _CategoryStyle(
        bgColor: const Color(0xFFFCE7F3),
        iconBgColor: Colors.white.withOpacity(0.6),
        iconColor: const Color(0xFFBE185D),
        icon: Icons.sentiment_very_satisfied,
      );
    } else if (name.contains('life') || iconName.contains('nature')) {
      return _CategoryStyle(
        bgColor: const Color(0xFFE0F2FE),
        iconBgColor: Colors.white.withOpacity(0.6),
        iconColor: const Color(0xFF0369A1),
        icon: Icons.spa,
      );
    } else if (name.contains('friendship') || iconName.contains('people')) {
      return _CategoryStyle(
        bgColor: const Color(0xFFFEF9C3),
        iconBgColor: Colors.white.withOpacity(0.6),
        iconColor: const Color(0xFFA16207),
        icon: Icons.people,
      );
    } else if (name.contains('happiness') || name.contains('joy')) {
      return _CategoryStyle(
        bgColor: const Color(0xFFFFFBEB),
        iconBgColor: Colors.white.withOpacity(0.6),
        iconColor: const Color(0xFFD97706),
        icon: Icons.emoji_emotions,
      );
    }

    // Default style for unknown categories
    return _CategoryStyle(
      bgColor: const Color(0xFFF1F5F9),
      iconBgColor: Colors.white.withOpacity(0.6),
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

/// Style configuration for category cards
class _CategoryStyle {
  const _CategoryStyle({
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

/// Individual category card widget
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.style,
    required this.onTap,
  });

  final CategoryModel? category;
  final _CategoryStyle style;
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
                  category?.name ?? 'Category',
                  style: AppTextStyles.categoryTitle.copyWith(
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Explore quotes',
                  style: AppTextStyles.subDetail.copyWith(
                    color: const Color(0xFF475569),
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

/// Wide category card for full width display
class _WideCategoryCard extends StatelessWidget {
  const _WideCategoryCard({
    required this.category,
    required this.style,
    required this.onTap,
  });

  final CategoryModel category;
  final _CategoryStyle style;
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
                      style: AppTextStyles.categoryTitleLarge.copyWith(
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Explore quotes',
                      style: AppTextStyles.subDetail.copyWith(
                        fontSize: 11,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Arrow
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: style.iconColor.withOpacity(0.3)),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: style.iconColor,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
