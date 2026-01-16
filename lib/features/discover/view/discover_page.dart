import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/features/discover/view/widgets/action_sidebar.dart';
import 'package:quote_vault/features/discover/view/widgets/background_layer.dart';
import 'package:quote_vault/features/discover/view/widgets/daily_insight_badge.dart';
import 'package:quote_vault/features/discover/view/widgets/quotes_content.dart';
import 'package:quote_vault/features/quotes/controller/pod/quotes_pod.dart';
import 'package:quote_vault/features/quotes/controller/state/quotes_states.dart';
import 'package:quote_vault/features/settings/controller/user_stats_provider.dart';
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
    // Initialize user stats (streak tracking)
    ref.watch(userStatsProvider);

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
                    data: (state) => QuotesContent(
                      state: state,
                      currentIndex: currentIndex,
                      pageController: _pageController,
                    ),
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
}
