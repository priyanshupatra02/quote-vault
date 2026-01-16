import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/features/collections/controller/pod/collections_pod.dart';
import 'package:quote_vault/features/collections/controller/state/collections_states.dart';
import 'package:quote_vault/features/favorites/controller/pod/favorites_pod.dart';
import 'package:share_plus/share_plus.dart';

class SavedQuoteCard extends ConsumerWidget {
  final QuoteModel quote;
  final bool isDark;

  const SavedQuoteCard({
    super.key,
    required this.quote,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(quote.id));

    return GestureDetector(
      onLongPress: () => _showQuoteOptions(context, ref),
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

  void _showQuoteOptions(BuildContext context, WidgetRef ref) {
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
                _showFolderPicker(context, ref);
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

  void _showFolderPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CollectionPickerSheet(quote: quote, isDark: isDark),
    );
  }
}

class _CollectionPickerSheet extends ConsumerStatefulWidget {
  final QuoteModel quote;
  final bool isDark;

  const _CollectionPickerSheet({
    required this.quote,
    required this.isDark,
  });

  @override
  ConsumerState<_CollectionPickerSheet> createState() => _CollectionPickerSheetState();
}

class _CollectionPickerSheetState extends ConsumerState<_CollectionPickerSheet> {
  // Track which collection is currently processing the add request
  int? _addingToCollectionId;

  @override
  Widget build(BuildContext context) {
    final collectionsState = ref.watch(collectionsProvider);

    return SafeArea(
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
                    color: widget.isDark ? Colors.white : const Color(0xFF1F2937),
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
                  physics: const ClampingScrollPhysics(), // Prevent scrolling inside sheet
                  itemCount: state.collections.length,
                  itemBuilder: (context, index) {
                    final collection = state.collections[index];
                    final isProcessing = _addingToCollectionId == collection.id;

                    // Check if quote is already in this collection
                    final quotesAsync = ref.watch(collectionQuotesProvider(collection.id));
                    final isAlreadyAdded = quotesAsync.when(
                      data: (quotes) => quotes.any((q) => q.id == widget.quote.id),
                      loading: () => false, // Don't block checking while loading
                      error: (_, __) => false,
                    );

                    return ListTile(
                      leading: Icon(
                        Icons.folder,
                        color: widget.isDark ? AppColors.primary : const Color(0xFF6366F1),
                      ),
                      title: Text(
                        collection.name,
                        style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: isAlreadyAdded
                          ? Text(
                              'Already added',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.isDark ? Colors.white38 : Colors.grey[500],
                              ),
                            )
                          : null,
                      trailing: isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : (isAlreadyAdded
                              ? Icon(
                                  Icons.check_circle,
                                  color: widget.isDark ? AppColors.primary : Colors.green,
                                  size: 20,
                                )
                              : null),
                      enabled: _addingToCollectionId == null && !isAlreadyAdded,
                      onTap: () async {
                        setState(() => _addingToCollectionId = collection.id);

                        final success =
                            await ref.read(collectionsProvider.notifier).addQuoteToCollection(
                                  collectionId: collection.id,
                                  quoteId: widget.quote.id,
                                );

                        // Invalidate the specific collection's quotes provider to refresh count/list
                        if (success) {
                          ref.invalidate(collectionQuotesProvider(collection.id));
                        }

                        if (mounted) {
                          setState(() => _addingToCollectionId = null);
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
                        }
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
                      color: widget.isDark ? Colors.white24 : Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No collections yet',
                      style: TextStyle(
                        color: widget.isDark ? Colors.white54 : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a folder first using the + button',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isDark ? Colors.white38 : Colors.grey[400],
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
    );
  }
}
