import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/features/discover/view/widgets/action_sidebar.dart';
import 'package:quote_vault/features/discover/view/widgets/background_layer.dart';
import 'package:quote_vault/features/discover/view/widgets/daily_insight_badge.dart';
import 'package:quote_vault/features/discover/view/widgets/quote_display.dart';
import 'package:quote_vault/features/quotes/controller/pod/quotes_pod.dart';
import 'package:quote_vault/features/quotes/controller/state/quotes_states.dart';
import 'package:quote_vault/shared/riverpod_ext/asynvalue_easy_when.dart';

@RoutePage()
class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotesState = ref.watch(quotesProvider);
    final currentIndex = ref.watch(currentQuoteIndexProvider);

    // Get current quote from state
    QuoteModel? currentQuote;
    quotesState.whenData((state) {
      if (state is QuotesLoadedState && state.quotes.isNotEmpty) {
        final idx = currentIndex.clamp(0, state.quotes.length - 1);
        currentQuote = state.quotes[idx];
      } else if (state is QuotesLoadingMoreState && state.currentQuotes.isNotEmpty) {
        final idx = currentIndex.clamp(0, state.currentQuotes.length - 1);
        currentQuote = state.currentQuotes[idx];
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background (Gradient + Noise)
          const BackgroundLayer(),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Header
                const Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 4.0),
                  child: Center(
                    child: DailyInsightBadge(),
                  ),
                ),

                // Quote Area
                Expanded(
                  child: quotesState.easyWhen(
                    data: (state) => _buildQuotesContent(state, currentIndex),
                    onRetry: () => ref.read(quotesProvider.notifier).refresh(),
                    includedefaultDioErrorMessage: true,
                  ),
                ),

                // Bottom Spacer
                const SizedBox(height: 20),
              ],
            ),
          ),

          // 3. Floating Action Sidebar (Right Side)
          Positioned(
            bottom: 32,
            right: 20,
            child: ActionSidebar(currentQuote: currentQuote),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotesContent(QuotesState state, int currentIndex) {
    if (state is QuotesLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is QuotesEmptyState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.format_quote, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (state is QuotesErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(quotesProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is QuotesLoadedState || state is QuotesLoadingMoreState) {
      final quotes = state is QuotesLoadedState
          ? state.quotes
          : (state as QuotesLoadingMoreState).currentQuotes;

      if (quotes.isEmpty) {
        return const Center(
          child: QuoteDisplay(
            quote: 'Swipe up to discover inspiring quotes',
            author: 'QuoteVault',
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => ref.read(quotesProvider.notifier).refresh(),
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: quotes.length,
          onPageChanged: (index) {
            ref.read(currentQuoteIndexProvider.notifier).state = index;

            // Load more when reaching near the end
            if (state is QuotesLoadedState && state.hasMore && index >= quotes.length - 3) {
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

    // Fallback for initial state
    return const Center(child: CircularProgressIndicator());
  }
}
