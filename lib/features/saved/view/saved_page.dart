import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/data/model/collection_model.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/features/collections/controller/pod/collections_pod.dart';
import 'package:quote_vault/features/collections/controller/state/collections_states.dart';
import 'package:quote_vault/features/favorites/controller/pod/favorites_pod.dart';
import 'package:quote_vault/features/favorites/controller/state/favorites_states.dart';
import 'package:quote_vault/shared/riverpod_ext/asynvalue_easy_when.dart';
import 'package:quote_vault/shared/widget/custom_loaders/app_loader.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Filter tabs for the vault
enum VaultFilter { all, favorites, folders }

@RoutePage()
class SavedPage extends ConsumerStatefulWidget {
  const SavedPage({super.key});

  @override
  ConsumerState<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {
  VaultFilter _selectedFilter = VaultFilter.all;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesProvider);
    final collectionsState = ref.watch(collectionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate total saved quotes
    int totalQuotes = 0;
    favoritesState.whenData((state) {
      if (state is FavoritesLoadedState) {
        totalQuotes = state.favorites.length;
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFCFCFD),
      body: CustomScrollView(
        slivers: [
          // Sticky Header

          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor:
                isDark ? AppColors.backgroundDark.withOpacity(0.95) : Colors.white.withOpacity(0.9),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search vault...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey[400],
                      ),
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    'My Vault',
                    style: AppTextStyles.display.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                      letterSpacing: -0.3,
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.close : Icons.search,
                  color: isDark ? Colors.white54 : Colors.grey[500],
                ),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                      _searchQuery = '';
                    }
                  });
                },
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_horiz,
                  color: isDark ? Colors.white54 : Colors.grey[500],
                ),
                color: isDark ? const Color(0xFF1F2937) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (value) async {
                  switch (value) {
                    case 'settings':
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings coming soon!')),
                      );
                      break;
                    case 'sign_out':
                      // Sign out functionality
                      final supabase = Supabase.instance.client;
                      await supabase.auth.signOut();

                      if (context.mounted) {
                        context.router.replaceAll([const LoginRoute()]);
                      }
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings,
                            size: 20, color: isDark ? Colors.white70 : Colors.grey[700]),
                        const SizedBox(width: 12),
                        Text('Settings',
                            style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'sign_out',
                    child: Row(
                      children: [
                        const Icon(Icons.logout, size: 20, color: Colors.red),
                        const SizedBox(width: 12),
                        const Text('Sign Out', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: isDark ? Colors.white10 : Colors.grey[100],
              ),
            ),
          ),

          // Cloud Sync Badge & Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  // Cloud Synced Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.primary.withOpacity(0.2) : const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isDark ? AppColors.primary.withOpacity(0.3) : const Color(0xFFC7D2FE),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_done,
                          size: 14,
                          color: isDark ? AppColors.primary : const Color(0xFF4338CA),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'CLOUD SYNCED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: isDark ? AppColors.primary : const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats
                  Text(
                    totalQuotes.toString(),
                    style: AppTextStyles.display.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Saved quotes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterTabsDelegate(
              selectedFilter: _selectedFilter,
              onFilterChanged: (filter) => setState(() => _selectedFilter = filter),
              isDark: isDark,
            ),
          ),

          // Content Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildContent(favoritesState, collectionsState, isDark),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateCollectionDialog(context, ref),
        backgroundColor: isDark ? AppColors.primary : const Color(0xFF1F2937),
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildContent(
    AsyncValue<FavoritesState> favoritesState,
    AsyncValue<CollectionsState> collectionsState,
    bool isDark,
  ) {
    switch (_selectedFilter) {
      case VaultFilter.all:
        return _buildMasonryGrid(favoritesState, collectionsState, isDark);
      case VaultFilter.favorites:
        return _buildFavoritesList(favoritesState, isDark);
      case VaultFilter.folders:
        return _buildFoldersList(collectionsState, isDark);
    }
  }

  Widget _buildMasonryGrid(
    AsyncValue<FavoritesState> favoritesState,
    AsyncValue<CollectionsState> collectionsState,
    bool isDark,
  ) {
    List<Widget> items = [];

    // Add favorites
    // Add favorites
    favoritesState.whenData((state) {
      if (state is FavoritesLoadedState) {
        final filteredFavorites = state.favorites.where((q) {
          if (_searchQuery.isEmpty) return true;
          return q.content.toLowerCase().contains(_searchQuery) ||
              q.author.toLowerCase().contains(_searchQuery);
        });
        for (final quote in filteredFavorites) {
          items.add(_QuoteCard(quote: quote, isDark: isDark, ref: ref));
        }
      }
    });

    // Add collections interspersed
    // Add collections interspersed
    collectionsState.whenData((state) {
      if (state is CollectionsLoadedState) {
        final filteredCollections = state.collections.where((c) {
          if (_searchQuery.isEmpty) return true;
          return c.name.toLowerCase().contains(_searchQuery);
        }).toList();

        for (int i = 0; i < filteredCollections.length; i++) {
          final insertAt = (i + 1) * 2;
          if (insertAt < items.length) {
            items.insert(insertAt, _FolderCard(collection: filteredCollections[i], isDark: isDark));
          } else {
            items.add(_FolderCard(collection: filteredCollections[i], isDark: isDark));
          }
        }
      }
    });

    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(isDark),
      );
    }

    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }

  Widget _buildFavoritesList(AsyncValue<FavoritesState> favoritesState, bool isDark) {
    return favoritesState.easyWhen(
      data: (state) {
        if (state is FavoritesLoadedState && state.favorites.isNotEmpty) {
          final filteredFavorites = state.favorites.where((q) {
            if (_searchQuery.isEmpty) return true;
            return q.content.toLowerCase().contains(_searchQuery) ||
                q.author.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredFavorites.isEmpty && _searchQuery.isNotEmpty) {
            return SliverToBoxAdapter(child: _buildEmptyState(isDark));
          }

          return SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: filteredFavorites.length,
            itemBuilder: (context, index) => _QuoteCard(
              quote: filteredFavorites[index],
              isDark: isDark,
              ref: ref,
            ),
          );
        }
        return SliverToBoxAdapter(child: _buildEmptyState(isDark));
      },
      loadingWidget: () => const SliverToBoxAdapter(
        child: Center(child: AppLoader()),
      ),
      errorWidget: (e, _) => SliverToBoxAdapter(
        child: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildFoldersList(AsyncValue<CollectionsState> collectionsState, bool isDark) {
    return collectionsState.easyWhen(
      data: (state) {
        if (state is CollectionsLoadedState && state.collections.isNotEmpty) {
          final filteredCollections = state.collections.where((c) {
            if (_searchQuery.isEmpty) return true;
            return c.name.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredCollections.isEmpty && _searchQuery.isNotEmpty) {
            return SliverToBoxAdapter(child: _buildEmptyState(isDark));
          }

          return SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: filteredCollections.length,
            itemBuilder: (context, index) => _FolderCard(
              collection: filteredCollections[index],
              isDark: isDark,
            ),
          );
        }
        return SliverToBoxAdapter(child: _buildEmptyState(isDark));
      },
      loadingWidget: () => const SliverToBoxAdapter(
        child: Center(child: AppLoader()),
      ),
      errorWidget: (e, _) => SliverToBoxAdapter(
        child: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No items yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white54 : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save quotes or create folders to see them here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Folder'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Folder name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(collectionsProvider.notifier).createCollection(
                      name: controller.text.trim(),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

/// Filter tabs delegate for sticky header
class _FilterTabsDelegate extends SliverPersistentHeaderDelegate {
  final VaultFilter selectedFilter;
  final ValueChanged<VaultFilter> onFilterChanged;
  final bool isDark;

  _FilterTabsDelegate({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFFCFCFD),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: VaultFilter.values.map((filter) {
            final isSelected = selectedFilter == filter;
            return Expanded(
              child: GestureDetector(
                onTap: () => onFilterChanged(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? Colors.white.withOpacity(0.1) : Colors.white)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected && !isDark
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      filter.name[0].toUpperCase() + filter.name.substring(1),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? (isDark ? Colors.white : const Color(0xFF1F2937))
                            : (isDark ? Colors.white38 : Colors.grey[500]),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant _FilterTabsDelegate oldDelegate) =>
      selectedFilter != oldDelegate.selectedFilter || isDark != oldDelegate.isDark;
}

/// Quote card widget
class _QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  final bool isDark;
  final WidgetRef ref;

  const _QuoteCard({
    required this.quote,
    required this.isDark,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isFavoriteProvider(quote.id));

    return GestureDetector(
      onLongPress: () => _showQuoteOptions(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]!,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // Favorite icon
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(quote),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color:
                      isFavorite ? Colors.red[400] : (isDark ? Colors.white24 : Colors.grey[300]),
                ),
              ),
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  '"${quote.content}"',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  quote.author,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white38 : Colors.grey[400],
                  ),
                ),
                if (quote.category != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey[100]!,
                      ),
                    ),
                    child: Text(
                      quote.category!.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: isDark ? Colors.white54 : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQuoteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.folder_open,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
              title: Text(
                'Add to Folder',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showFolderPicker(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
              title: Text(
                'Share Quote',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Share.share('${quote.content}\n\n- ${quote.author}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Remove from Favorites',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                ref.read(favoritesProvider.notifier).removeFromFavorites(quote.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Removed from favorites')),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showFolderPicker(BuildContext context) {
    final collectionsState = ref.read(collectionsProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Add to Folder',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            collectionsState.when(
              data: (state) {
                if (state is CollectionsLoadedState && state.collections.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.collections.length,
                    itemBuilder: (context, index) {
                      final collection = state.collections[index];
                      return ListTile(
                        leading: Icon(
                          Icons.folder,
                          color: isDark ? AppColors.primary : const Color(0xFF6366F1),
                        ),
                        title: Text(
                          collection.name,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () async {
                          final success =
                              await ref.read(collectionsProvider.notifier).addQuoteToCollection(
                                    collectionId: collection.id,
                                    quoteId: quote.id,
                                  );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Added to "${collection.name}"'
                                    : 'Failed to add to folder',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 48,
                        color: isDark ? Colors.white24 : Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No folders yet',
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create a folder first using the + button',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(32),
                child: Text('Error: $e'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Folder card widget
class _FolderCard extends ConsumerWidget {
  final CollectionModel collection;
  final bool isDark;

  const _FolderCard({
    required this.collection,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _openFolderDetail(context, ref),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.primary.withOpacity(0.1) : const Color(0xFFF0F5FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.primary.withOpacity(0.2) : const Color(0xFFC7D2FE),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.folder,
                  size: 32,
                  color: isDark ? AppColors.primary : const Color(0xFF6366F1),
                ),
                // Functional popup menu
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    size: 20,
                    color: isDark ? Colors.white24 : Colors.grey[400],
                  ),
                  onSelected: (value) => _handleMenuAction(context, ref, value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'rename',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Rename'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              collection.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Consumer(
              builder: (context, ref, _) {
                final quotesAsync = ref.watch(collectionQuotesProvider(collection.id));
                return quotesAsync.when(
                  data: (quotes) => Text(
                    '${quotes.length} quote${quotes.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white38 : Colors.grey[500],
                    ),
                  ),
                  loading: () => Text(
                    '...',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white38 : Colors.grey[500],
                    ),
                  ),
                  error: (_, __) => Text(
                    '0 quotes',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white38 : Colors.grey[500],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openFolderDetail(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),

              // Header Area with stats
              Consumer(
                builder: (context, ref, _) {
                  final quotesAsync = ref.watch(collectionQuotesProvider(collection.id));
                  final count = quotesAsync.asData?.value.length ?? 0;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.primary.withOpacity(0.2)
                                          : const Color(0xFFE0E7FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.folder_rounded,
                                      size: 24,
                                      color: isDark ? AppColors.primary : const Color(0xFF4338CA),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          collection.name,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.5,
                                            color: isDark ? Colors.white : const Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$count saved quotes',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: isDark ? Colors.white54 : Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                            highlightColor: Colors.transparent,
                          ),
                          icon: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Divider
              Container(
                height: 1,
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
              ),

              // Quotes list
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final quotesAsync = ref.watch(collectionQuotesProvider(collection.id));
                    return quotesAsync.when(
                      data: (quotes) {
                        if (quotes.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color:
                                        isDark ? Colors.white.withOpacity(0.03) : Colors.grey[50],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.auto_stories_outlined,
                                    size: 48,
                                    color: isDark ? Colors.white24 : Colors.indigo[100],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Empty Folder',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    'Start collecting your favorite quotes here by long-pressing any quote card.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: isDark ? Colors.white54 : Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.all(24),
                          itemCount: quotes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final quote = quotes[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDark ? Colors.white10 : Colors.grey[100]!,
                                ),
                                boxShadow: isDark
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {}, // Optional details view
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.format_quote_rounded,
                                              size: 20,
                                              color: Colors.indigo,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                quote.content,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.6,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color(0xFF1F2937),
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 1,
                                                  color: isDark ? Colors.white24 : Colors.grey[300],
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  quote.author,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        isDark ? Colors.white54 : Colors.grey[500],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // Remove button
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () async {
                                                  // Optional: Add haptic feedback here
                                                  await ref
                                                      .read(collectionsProvider.notifier)
                                                      .removeQuoteFromCollection(
                                                        collectionId: collection.id,
                                                        quoteId: quote.id,
                                                      );
                                                  ref.invalidate(
                                                      collectionQuotesProvider(collection.id));
                                                },
                                                borderRadius: BorderRadius.circular(8),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Icon(
                                                    Icons.delete_outline_rounded,
                                                    size: 20,
                                                    color:
                                                        isDark ? Colors.white38 : Colors.grey[400],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'rename':
        _showRenameDialog(context, ref);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref);
        break;
    }
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: collection.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Folder'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Folder name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                // TODO: Implement rename in SupabaseHelper and notifier
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rename coming soon')),
                );
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder?'),
        content: Text(
          'Are you sure you want to delete "${collection.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(collectionsProvider.notifier).deleteCollection(collection.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"${collection.name}" deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
