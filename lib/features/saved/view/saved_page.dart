import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/collections/controller/pod/collections_pod.dart';
import 'package:quote_vault/features/collections/controller/state/collections_states.dart';
import 'package:quote_vault/features/favorites/controller/pod/favorites_pod.dart';
import 'package:quote_vault/features/favorites/controller/state/favorites_states.dart';
import 'package:quote_vault/features/saved/controller/pod/saved_page_providers.dart';
import 'package:quote_vault/features/saved/view/widgets/create_collection_dialog.dart';
import 'package:quote_vault/features/saved/view/widgets/filter_tabs_delegate.dart';
import 'package:quote_vault/features/saved/view/widgets/saved_collection_card.dart';
import 'package:quote_vault/features/saved/view/widgets/saved_empty_state.dart';
import 'package:quote_vault/features/saved/view/widgets/saved_quote_card.dart';
import 'package:quote_vault/shared/riverpod_ext/asynvalue_easy_when.dart';
import 'package:quote_vault/shared/widget/custom_loaders/app_loader.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class SavedPage extends ConsumerStatefulWidget {
  const SavedPage({super.key});

  @override
  ConsumerState<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(vaultSearchQueryProvider.notifier).state =
          _searchController.text.trim().toLowerCase();
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
    final selectedFilter = ref.watch(vaultFilterProvider);
    final isSearching = ref.watch(vaultSearchModeProvider);
    final searchQuery = ref.watch(vaultSearchQueryProvider);

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
            title: isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search vault...',
                      hintStyle: AppTextStyles.searchHint(context).copyWith(
                        color: isDark ? Colors.white38 : Colors.grey[400],
                      ),
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    'My Vault',
                    style: AppTextStyles.pageTitle(context).copyWith(
                      fontSize: 24,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(
                  isSearching ? Icons.close : Icons.search,
                  color: isDark ? Colors.white54 : Colors.grey[500],
                ),
                onPressed: () {
                  final currentSearching = ref.read(vaultSearchModeProvider);
                  ref.read(vaultSearchModeProvider.notifier).state = !currentSearching;
                  if (currentSearching) {
                    _searchController.clear();
                    ref.read(vaultSearchQueryProvider.notifier).state = '';
                  }
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
                          style: AppTextStyles.sectionLabel(context).copyWith(
                            fontSize: 10,
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
                    style: AppTextStyles.pageTitle(context).copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Saved quotes',
                    style: AppTextStyles.subDetail(context).copyWith(
                      fontSize: 14,
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
            delegate: FilterTabsDelegate(
              selectedFilter: selectedFilter,
              onFilterChanged: (filter) => ref.read(vaultFilterProvider.notifier).state = filter,
              isDark: isDark,
            ),
          ),

          // Content Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _VaultContent(
              favoritesState: favoritesState,
              collectionsState: collectionsState,
              isDark: isDark,
              selectedFilter: selectedFilter,
              searchQuery: searchQuery,
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateCollectionDialog(context, ref),
        backgroundColor: isDark ? AppColors.primary : const Color(0xFF1F2937),
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class _VaultContent extends StatelessWidget {
  const _VaultContent({
    required this.favoritesState,
    required this.collectionsState,
    required this.isDark,
    required this.selectedFilter,
    required this.searchQuery,
  });

  final AsyncValue<FavoritesState> favoritesState;
  final AsyncValue<CollectionsState> collectionsState;
  final bool isDark;
  final VaultFilter selectedFilter;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    switch (selectedFilter) {
      case VaultFilter.all:
        return _VaultMasonryGrid(
          favoritesState: favoritesState,
          collectionsState: collectionsState,
          isDark: isDark,
          searchQuery: searchQuery,
        );
      case VaultFilter.favorites:
        return _VaultFavoritesList(
          favoritesState: favoritesState,
          isDark: isDark,
          searchQuery: searchQuery,
        );
      case VaultFilter.collections:
        return _VaultCollectionsList(
          collectionsState: collectionsState,
          isDark: isDark,
          searchQuery: searchQuery,
        );
    }
  }
}

class _VaultMasonryGrid extends StatelessWidget {
  const _VaultMasonryGrid({
    required this.favoritesState,
    required this.collectionsState,
    required this.isDark,
    required this.searchQuery,
  });

  final AsyncValue<FavoritesState> favoritesState;
  final AsyncValue<CollectionsState> collectionsState;
  final bool isDark;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    // Add favorites
    favoritesState.whenData((state) {
      if (state is FavoritesLoadedState) {
        final filteredFavorites = state.favorites.where((q) {
          if (searchQuery.isEmpty) return true;
          return q.content.toLowerCase().contains(searchQuery) ||
              q.author.toLowerCase().contains(searchQuery);
        });
        for (final quote in filteredFavorites) {
          items.add(SavedQuoteCard(quote: quote, isDark: isDark));
        }
      }
    });

    // Add collections interspersed
    collectionsState.whenData((state) {
      if (state is CollectionsLoadedState) {
        final filteredCollections = state.collections.where((c) {
          if (searchQuery.isEmpty) return true;
          return c.name.toLowerCase().contains(searchQuery);
        }).toList();

        for (int i = 0; i < filteredCollections.length; i++) {
          final insertAt = (i + 1) * 2;
          if (insertAt < items.length) {
            items.insert(
                insertAt, SavedCollectionCard(collection: filteredCollections[i], isDark: isDark));
          } else {
            items.add(SavedCollectionCard(collection: filteredCollections[i], isDark: isDark));
          }
        }
      }
    });

    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: SavedEmptyState(isDark: isDark),
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
}

class _VaultFavoritesList extends StatelessWidget {
  const _VaultFavoritesList({
    required this.favoritesState,
    required this.isDark,
    required this.searchQuery,
  });

  final AsyncValue<FavoritesState> favoritesState;
  final bool isDark;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return favoritesState.easyWhen(
      data: (state) {
        if (state is FavoritesLoadedState && state.favorites.isNotEmpty) {
          final filteredFavorites = state.favorites.where((q) {
            if (searchQuery.isEmpty) return true;
            return q.content.toLowerCase().contains(searchQuery) ||
                q.author.toLowerCase().contains(searchQuery);
          }).toList();

          if (filteredFavorites.isEmpty && searchQuery.isNotEmpty) {
            return SliverToBoxAdapter(child: SavedEmptyState(isDark: isDark));
          }

          return SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: filteredFavorites.length,
            itemBuilder: (context, index) => SavedQuoteCard(
              quote: filteredFavorites[index],
              isDark: isDark,
            ),
          );
        }
        return SliverToBoxAdapter(child: SavedEmptyState(isDark: isDark));
      },
      loadingWidget: () => const SliverToBoxAdapter(
        child: Center(child: AppLoader()),
      ),
      errorWidget: (e, _) => SliverToBoxAdapter(
        child: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _VaultCollectionsList extends StatelessWidget {
  const _VaultCollectionsList({
    required this.collectionsState,
    required this.isDark,
    required this.searchQuery,
  });

  final AsyncValue<CollectionsState> collectionsState;
  final bool isDark;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return collectionsState.easyWhen(
      data: (state) {
        if (state is CollectionsLoadedState && state.collections.isNotEmpty) {
          final filteredCollections = state.collections.where((c) {
            if (searchQuery.isEmpty) return true;
            return c.name.toLowerCase().contains(searchQuery);
          }).toList();

          if (filteredCollections.isEmpty && searchQuery.isNotEmpty) {
            return SliverToBoxAdapter(child: SavedEmptyState(isDark: isDark));
          }

          return SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: filteredCollections.length,
            itemBuilder: (context, index) => SavedCollectionCard(
              collection: filteredCollections[index],
              isDark: isDark,
            ),
          );
        }
        return SliverToBoxAdapter(child: SavedEmptyState(isDark: isDark));
      },
      loadingWidget: () => const SliverToBoxAdapter(
        child: Center(child: AppLoader()),
      ),
      errorWidget: (e, _) => SliverToBoxAdapter(
        child: Center(child: Text('Error: $e')),
      ),
    );
  }
}
