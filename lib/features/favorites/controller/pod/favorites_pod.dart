import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/features/favorites/controller/notifier/favorites_notifier.dart';
import 'package:quote_vault/features/favorites/controller/state/favorites_states.dart';

/// Provider for favorites state
final favoritesProvider = AsyncNotifierProvider.autoDispose<FavoritesNotifier, FavoritesState>(
  FavoritesNotifier.new,
  name: 'favoritesProvider',
);

/// Convenience provider to check if a specific quote is favorited
final isFavoriteProvider = Provider.family<bool, int>((ref, quoteId) {
  final favoritesState = ref.watch(favoritesProvider);
  return favoritesState.whenOrNull(
        data: (state) {
          if (state is FavoritesLoadedState) {
            return state.favorites.any((q) => q.id == quoteId);
          }
          if (state is FavoriteActionInProgress) {
            return state.currentFavorites.any((q) => q.id == quoteId);
          }
          return false;
        },
      ) ??
      false;
});
