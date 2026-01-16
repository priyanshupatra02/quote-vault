import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/model/collection_model.dart';
import 'package:quote_vault/data/network/supabase_client_pod.dart';
import 'package:quote_vault/data/network/supabase_helper_pod.dart';
import 'package:quote_vault/features/collections/controller/state/collections_states.dart';

/// Collections notifier for managing user's collections
class CollectionsNotifier extends AutoDisposeAsyncNotifier<CollectionsState> {
  @override
  FutureOr<CollectionsState> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return const CollectionsEmptyState();
    }

    final result = await ref.read(supabaseHelperProvider).getCollections(
          userId: user.id,
        );

    return result.when(
      (collections) => collections.isEmpty
          ? const CollectionsEmptyState()
          : CollectionsLoadedState(collections: collections),
      (error) => CollectionsErrorState(message: error.errorMessage),
    );
  }

  /// Create new collection
  Future<void> createCollection({
    required String name,
    String? iconName,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final currentState = state.valueOrNull;
    final currentCollections =
        currentState is CollectionsLoadedState ? currentState.collections : <CollectionModel>[];

    state = AsyncData(CollectionCreatingState(
      currentCollections: currentCollections,
    ));

    final result = await ref.read(supabaseHelperProvider).createCollection(
          userId: user.id,
          name: name,
          iconName: iconName,
        );

    state = AsyncData(result.when(
      (newCollection) {
        final updatedCollections = [newCollection, ...currentCollections];
        return CollectionsLoadedState(collections: updatedCollections);
      },
      (error) => CollectionsErrorState(message: error.errorMessage),
    ));
  }

  /// Delete collection
  Future<void> deleteCollection(int collectionId) async {
    final currentState = state.valueOrNull;
    if (currentState is! CollectionsLoadedState) return;

    final result = await ref.read(supabaseHelperProvider).deleteCollection(
          collectionId: collectionId,
        );

    state = AsyncData(result.when(
      (_) {
        final updatedCollections =
            currentState.collections.where((c) => c.id != collectionId).toList();
        return updatedCollections.isEmpty
            ? const CollectionsEmptyState()
            : CollectionsLoadedState(collections: updatedCollections);
      },
      (error) => CollectionsErrorState(message: error.errorMessage),
    ));
  }

  /// Add quote to collection
  Future<bool> addQuoteToCollection({
    required int collectionId,
    required int quoteId,
  }) async {
    final result = await ref.read(supabaseHelperProvider).addToCollection(
          collectionId: collectionId,
          quoteId: quoteId,
        );

    return result.when(
      (_) {
        // Invalidate to refresh state
        ref.invalidateSelf();
        return true;
      },
      (error) => false,
    );
  }

  /// Remove quote from collection
  Future<bool> removeQuoteFromCollection({
    required int collectionId,
    required int quoteId,
  }) async {
    final result = await ref.read(supabaseHelperProvider).removeFromCollection(
          collectionId: collectionId,
          quoteId: quoteId,
        );

    return result.when(
      (_) {
        // Invalidate to refresh state
        ref.invalidateSelf();
        return true;
      },
      (error) => false,
    );
  }

  /// Refresh collections
  Future<void> refresh() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = const AsyncData(CollectionsEmptyState());
      return;
    }

    state = const AsyncData(CollectionsLoadingState());

    final result = await ref.read(supabaseHelperProvider).getCollections(
          userId: user.id,
        );

    state = AsyncData(result.when(
      (collections) => collections.isEmpty
          ? const CollectionsEmptyState()
          : CollectionsLoadedState(collections: collections),
      (error) => CollectionsErrorState(message: error.errorMessage),
    ));
  }
}
