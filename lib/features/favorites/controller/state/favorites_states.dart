import 'package:quote_vault/data/model/quote_model.dart';

/// Sealed class for favorites state management
sealed class FavoritesState {
  const FavoritesState();
}

/// Initial state
class FavoritesInitialState implements FavoritesState {
  const FavoritesInitialState();
}

/// Loading state
class FavoritesLoadingState implements FavoritesState {
  const FavoritesLoadingState();
}

/// Favorites loaded successfully
class FavoritesLoadedState implements FavoritesState {
  final List<QuoteModel> favorites;

  const FavoritesLoadedState({required this.favorites});

  FavoritesLoadedState copyWith({List<QuoteModel>? favorites}) {
    return FavoritesLoadedState(favorites: favorites ?? this.favorites);
  }
}

/// Empty state
class FavoritesEmptyState implements FavoritesState {
  const FavoritesEmptyState();
}

/// Error state
class FavoritesErrorState implements FavoritesState {
  final String message;

  const FavoritesErrorState({required this.message});
}

/// Adding/Removing favorite in progress
class FavoriteActionInProgress implements FavoritesState {
  final List<QuoteModel> currentFavorites;
  final int quoteId;

  const FavoriteActionInProgress({
    required this.currentFavorites,
    required this.quoteId,
  });
}
