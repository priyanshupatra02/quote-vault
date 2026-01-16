import 'package:quote_vault/data/model/collection_model.dart';

/// Sealed class for collections state management
sealed class CollectionsState {
  const CollectionsState();
}

/// Initial state
class CollectionsInitialState implements CollectionsState {
  const CollectionsInitialState();
}

/// Loading state
class CollectionsLoadingState implements CollectionsState {
  const CollectionsLoadingState();
}

/// Collections loaded successfully
class CollectionsLoadedState implements CollectionsState {
  final List<CollectionModel> collections;

  const CollectionsLoadedState({required this.collections});

  CollectionsLoadedState copyWith({List<CollectionModel>? collections}) {
    return CollectionsLoadedState(collections: collections ?? this.collections);
  }
}

/// Empty state
class CollectionsEmptyState implements CollectionsState {
  const CollectionsEmptyState();
}

/// Error state
class CollectionsErrorState implements CollectionsState {
  final String message;

  const CollectionsErrorState({required this.message});
}

/// Creating collection in progress
class CollectionCreatingState implements CollectionsState {
  final List<CollectionModel> currentCollections;

  const CollectionCreatingState({required this.currentCollections});
}
