import 'package:quote_vault/data/model/quote_model.dart';

/// Sealed class for quotes state management
sealed class QuotesState {
  const QuotesState();
}

/// Initial state
class QuotesInitialState implements QuotesState {
  const QuotesInitialState();
}

/// Loading state - fetching quotes
class QuotesLoadingState implements QuotesState {
  const QuotesLoadingState();
}

/// Loading more quotes (pagination)
class QuotesLoadingMoreState implements QuotesState {
  final List<QuoteModel> currentQuotes;

  const QuotesLoadingMoreState(this.currentQuotes);
}

/// Quotes loaded successfully
class QuotesLoadedState implements QuotesState {
  final List<QuoteModel> quotes;
  final bool hasMore;
  final int currentPage;

  const QuotesLoadedState({
    required this.quotes,
    this.hasMore = true,
    this.currentPage = 0,
  });

  QuotesLoadedState copyWith({
    List<QuoteModel>? quotes,
    bool? hasMore,
    int? currentPage,
  }) {
    return QuotesLoadedState(
      quotes: quotes ?? this.quotes,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Empty state - no quotes found
class QuotesEmptyState implements QuotesState {
  final String message;

  const QuotesEmptyState({this.message = 'No quotes found'});
}

/// Error state
class QuotesErrorState implements QuotesState {
  final String message;

  const QuotesErrorState({required this.message});

  @override
  bool operator ==(covariant QuotesErrorState other) {
    if (identical(this, other)) return true;
    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
