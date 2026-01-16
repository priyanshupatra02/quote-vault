import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/features/discover/view/widgets/quote_display.dart';
import 'package:quote_vault/features/quotes/controller/pod/quotes_pod.dart';

class QuotesPageView extends ConsumerWidget {
  const QuotesPageView({
    super.key,
    required this.quotes,
    required this.pageController,
    required this.hasMore,
  });

  final List<QuoteModel> quotes;
  final PageController pageController;
  final bool hasMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(quotesProvider.notifier).refresh(),
      child: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: quotes.length,
        onPageChanged: (index) {
          ref.read(currentQuoteIndexProvider.notifier).state = index;

          // Load more when reaching near the end
          if (hasMore && index >= quotes.length - 3) {
            ref.read(quotesProvider.notifier).loadMore();
          }
        },
        itemBuilder: (context, index) {
          final quote = quotes[index];
          return Center(
            child: QuoteDisplay(
              quote: quote.content,
              author: quote.author.toUpperCase(),
            ),
          );
        },
      ),
    );
  }
}
