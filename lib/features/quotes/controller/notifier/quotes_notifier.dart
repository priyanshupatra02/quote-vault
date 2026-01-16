import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/data/network/supabase_helper_pod.dart';
import 'package:quote_vault/features/quotes/controller/state/quotes_states.dart';

/// Quotes notifier for fetching and managing quotes from Supabase
class QuotesNotifier extends AutoDisposeAsyncNotifier<QuotesState> {
  static const int _pageSize = 20;

  @override
  FutureOr<QuotesState> build() async {
    // Initial load
    return _loadQuotes(page: 0);
  }

  /// Load quotes with pagination
  Future<QuotesState> _loadQuotes({
    required int page,
    int? categoryId,
    String? searchQuery,
  }) async {
    final result = await ref.read(supabaseHelperProvider).getQuotes(
          page: page,
          pageSize: _pageSize,
          categoryId: categoryId,
          searchQuery: searchQuery,
        );

    return result.when(
      (quotes) {
        if (quotes.isEmpty && page == 0) {
          return const QuotesEmptyState();
        }
        return QuotesLoadedState(
          quotes: quotes,
          hasMore: quotes.length >= _pageSize,
          currentPage: page,
        );
      },
      (error) => QuotesErrorState(message: error.errorMessage),
    );
  }

  /// Refresh quotes (pull to refresh)
  Future<void> refresh() async {
    state = const AsyncData(QuotesLoadingState());
    state = AsyncData(await _loadQuotes(page: 0));
  }

  /// Load more quotes (infinite scroll)
  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState is! QuotesLoadedState || !currentState.hasMore) {
      return;
    }

    state = AsyncData(QuotesLoadingMoreState(currentState.quotes));

    final result = await ref.read(supabaseHelperProvider).getQuotes(
          page: currentState.currentPage + 1,
          pageSize: _pageSize,
        );

    state = AsyncData(result.when(
      (newQuotes) {
        final allQuotes = [...currentState.quotes, ...newQuotes];
        return QuotesLoadedState(
          quotes: allQuotes,
          hasMore: newQuotes.length >= _pageSize,
          currentPage: currentState.currentPage + 1,
        );
      },
      (error) => currentState, // Keep current state on error
    ));
  }

  /// Filter by category
  Future<void> filterByCategory(int? categoryId) async {
    state = const AsyncData(QuotesLoadingState());
    state = AsyncData(await _loadQuotes(page: 0, categoryId: categoryId));
  }

  /// Search quotes
  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncData(QuotesLoadingState());
      state = AsyncData(await _loadQuotes(page: 0));
      return;
    }

    state = const AsyncData(QuotesLoadingState());

    final result = await ref.read(supabaseHelperProvider).searchQuotes(query: query);

    state = AsyncData(result.when(
      (quotes) => quotes.isEmpty
          ? QuotesEmptyState(message: 'No quotes found for "$query"')
          : QuotesLoadedState(quotes: quotes, hasMore: false, currentPage: 0),
      (error) => QuotesErrorState(message: error.errorMessage),
    ));
  }
}

/// Daily quote notifier
class DailyQuoteNotifier extends AutoDisposeAsyncNotifier<QuoteModel?> {
  @override
  FutureOr<QuoteModel?> build() async {
    final result = await ref.read(supabaseHelperProvider).getDailyQuote();
    return result.when(
      (quote) => quote,
      (error) => null,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final result = await ref.read(supabaseHelperProvider).getDailyQuote();
    state = AsyncData(result.when(
      (quote) => quote,
      (error) => null,
    ));
  }
}
