import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/features/discover/view/widgets/action_sidebar.dart';
import 'package:quote_vault/features/discover/view/widgets/background_layer.dart';
import 'package:quote_vault/features/discover/view/widgets/daily_insight_badge.dart';
import 'package:quote_vault/features/discover/view/widgets/quote_display.dart';

@RoutePage()
class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Ensure the keyboard or notches don't obscure content inappropriately
      body: Stack(
        children: [
          // 1. Background (Gradient + Noise)
          BackgroundLayer(),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Header
                Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 4.0),
                  child: Center(
                    child: DailyInsightBadge(),
                  ),
                ),

                // Quote Area (Flex Expanded to center it)
                Expanded(
                  child: Center(
                    child: QuoteDisplay(
                      quote: 'The only way to do great work is to love what you do.',
                      author: 'STEVE JOBS',
                    ),
                  ),
                ),

                // Bottom Spacer (reduced since navbar is now at parent level)
                SizedBox(height: 20),
              ],
            ),
          ),

          // 3. Floating Action Sidebar (Right Side)
          Positioned(
            bottom: 32,
            right: 20,
            child: ActionSidebar(),
          ),
        ],
      ),
    );
  }
}
