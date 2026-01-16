import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/data/network/supabase_client_pod.dart';
import 'package:quote_vault/data/network/supabase_helper_pod.dart';
import 'package:quote_vault/features/favorites/controller/state/favorites_states.dart';

/// Favorites notifier for managing user's favorite quotes
class FavoritesNotifier extends AutoDisposeAsyncNotifier<FavoritesState> {
  @override
  FutureOr<FavoritesState> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return const FavoritesEmptyState();
    }

    final result = await ref.read(supabaseHelperProvider).getFavorites(
          userId: user.id,
        );

    return result.when(
      (favorites) => favorites.isEmpty
          ? const FavoritesEmptyState()
          : FavoritesLoadedState(favorites: favorites),
      (error) => FavoritesErrorState(message: error.errorMessage),
    );
  }

  /// Add quote to favorites
  Future<void> addToFavorites(QuoteModel quote) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final currentState = state.valueOrNull;
    List<QuoteModel> currentFavorites = [];
    if (currentState is FavoritesLoadedState) {
      currentFavorites = currentState.favorites;
    }

    state = AsyncData(FavoriteActionInProgress(
      currentFavorites: currentFavorites,
      quoteId: quote.id,
    ));

    final result = await ref.read(supabaseHelperProvider).addToFavorites(
          userId: user.id,
          quoteId: quote.id,
        );

    state = AsyncData(result.when(
      (_) {
        final updatedFavorites = [quote, ...currentFavorites];
        return FavoritesLoadedState(favorites: updatedFavorites);
      },
      (error) => FavoritesErrorState(message: error.errorMessage),
    ));
  }

  /// Remove quote from favorites
  Future<void> removeFromFavorites(int quoteId) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final currentState = state.valueOrNull;
    if (currentState is! FavoritesLoadedState) return;

    state = AsyncData(FavoriteActionInProgress(
      currentFavorites: currentState.favorites,
      quoteId: quoteId,
    ));

    final result = await ref.read(supabaseHelperProvider).removeFromFavorites(
          userId: user.id,
          quoteId: quoteId,
        );

    state = AsyncData(result.when(
      (_) {
        final updatedFavorites = currentState.favorites.where((q) => q.id != quoteId).toList();
        return updatedFavorites.isEmpty
            ? const FavoritesEmptyState()
            : FavoritesLoadedState(favorites: updatedFavorites);
      },
      (error) => FavoritesErrorState(message: error.errorMessage),
    ));
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(QuoteModel quote) async {
    final currentState = state.valueOrNull;
    bool isFavorited = false;

    if (currentState is FavoritesLoadedState) {
      isFavorited = currentState.favorites.any((q) => q.id == quote.id);
    } else if (currentState is FavoriteActionInProgress) {
      isFavorited = currentState.currentFavorites.any((q) => q.id == quote.id);
    }

    if (isFavorited) {
      await removeFromFavorites(quote.id);
    } else {
      await addToFavorites(quote);
    }
  }

  /// Check if a quote is favorited
  bool isFavorite(int quoteId) {
    final currentState = state.valueOrNull;
    if (currentState is FavoritesLoadedState) {
      return currentState.favorites.any((q) => q.id == quoteId);
    }
    return false;
  }

  /// Refresh favorites
  Future<void> refresh() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = const AsyncData(FavoritesEmptyState());
      return;
    }

    state = const AsyncData(FavoritesLoadingState());

    final result = await ref.read(supabaseHelperProvider).getFavorites(
          userId: user.id,
        );

    state = AsyncData(result.when(
      (favorites) => favorites.isEmpty
          ? const FavoritesEmptyState()
          : FavoritesLoadedState(favorites: favorites),
      (error) => FavoritesErrorState(message: error.errorMessage),
    ));
  }
}
