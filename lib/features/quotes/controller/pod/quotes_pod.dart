import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/features/quotes/controller/notifier/quotes_notifier.dart';
import 'package:quote_vault/features/quotes/controller/state/quotes_states.dart';

/// Provider for quotes state - main feed
final quotesProvider = AsyncNotifierProvider.autoDispose<QuotesNotifier, QuotesState>(
  QuotesNotifier.new,
  name: 'quotesProvider',
);

/// Provider for daily quote
final dailyQuoteProvider = AsyncNotifierProvider.autoDispose<DailyQuoteNotifier, QuoteModel?>(
  DailyQuoteNotifier.new,
  name: 'dailyQuoteProvider',
);

/// Provider for current quote index (for swipe navigation)
final currentQuoteIndexProvider = StateProvider<int>(
  (ref) => 0,
  name: 'currentQuoteIndexProvider',
);

/// Provider for selected category filter
final selectedCategoryProvider = StateProvider<int?>(
  (ref) => null,
  name: 'selectedCategoryProvider',
);
