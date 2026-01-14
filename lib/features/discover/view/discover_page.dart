import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/features/discover/view/widgets/action_sidebar.dart';
import 'package:quote_vault/features/discover/view/widgets/background_layer.dart';
import 'package:quote_vault/features/discover/view/widgets/custom_bottom_nav_bar.dart';
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

                // Bottom Spacer to accommodate Navbar + Actions
                // Sidebar overlaps, Navbar is fixed at bottom
                // We add space here so scrollable content wouldn't hide behind nav
                SizedBox(height: 100),
              ],
            ),
          ),

          // 3. Floating Action Sidebar (Right Side)
          Positioned(
            bottom: 112, // 84 (nav) + 28 (bottom-28)
            right: 20, // right-5 (5 * 4 = 20)
            child: ActionSidebar(),
          ),

          // 4. Bottom Navbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(),
          ),
        ],
      ),
    );
  }
}
