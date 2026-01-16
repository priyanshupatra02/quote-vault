import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/features/discover/view/widgets/empty_quotes_view.dart';
import 'package:quote_vault/features/discover/view/widgets/error_quotes_view.dart';
import 'package:quote_vault/features/discover/view/widgets/quote_display.dart';
import 'package:quote_vault/features/discover/view/widgets/quotes_page_view.dart';
import 'package:quote_vault/features/quotes/controller/state/quotes_states.dart';
import 'package:quote_vault/shared/widget/custom_loaders/app_loader.dart';

class QuotesContent extends ConsumerWidget {
  const QuotesContent({
    super.key,
    required this.state,
    required this.currentIndex,
    required this.pageController,
  });

  final QuotesState state;
  final int currentIndex;
  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state is QuotesLoadingState) {
      return const Center(child: AppLoader());
    }

    if (state is QuotesEmptyState) {
      return EmptyQuotesView(message: (state as QuotesEmptyState).message);
    }

    if (state is QuotesErrorState) {
      return ErrorQuotesView(message: (state as QuotesErrorState).message);
    }

    if (state is QuotesLoadedState || state is QuotesLoadingMoreState) {
      final quotes = state is QuotesLoadedState
          ? (state as QuotesLoadedState).quotes
          : (state as QuotesLoadingMoreState).currentQuotes;

      if (quotes.isEmpty) {
        return const Center(
          child: QuoteDisplay(
            quote: 'Swipe up to discover inspiring quotes',
            author: 'QuoteVault',
          ),
        );
      }

      return QuotesPageView(
        quotes: quotes,
        pageController: pageController,
        hasMore: state is QuotesLoadedState ? (state as QuotesLoadedState).hasMore : false,
      );
    }

    // Fallback for initial state
    return const Center(child: AppLoader());
  }
}
