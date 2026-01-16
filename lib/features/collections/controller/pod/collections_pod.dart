import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/data/network/supabase_helper_pod.dart';
import 'package:quote_vault/features/collections/controller/notifier/collections_notifier.dart';
import 'package:quote_vault/features/collections/controller/state/collections_states.dart';

/// Provider for collections state
final collectionsProvider =
    AsyncNotifierProvider.autoDispose<CollectionsNotifier, CollectionsState>(
  CollectionsNotifier.new,
  name: 'collectionsProvider',
);

/// Provider to get quotes in a specific collection
final collectionQuotesProvider =
    FutureProvider.autoDispose.family<List<QuoteModel>, int>((ref, collectionId) async {
  final result = await ref.watch(supabaseHelperProvider).getCollectionQuotes(
        collectionId: collectionId,
      );
  return result.when(
    (quotes) => quotes,
    (error) => [],
  );
});
