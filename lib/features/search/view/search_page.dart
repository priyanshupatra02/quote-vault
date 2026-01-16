import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/discover/view/widgets/background_layer.dart';
import 'package:quote_vault/features/discover/view/widgets/custom_bottom_nav_bar.dart';
import 'package:quote_vault/features/search/view/widgets/author_result_tile.dart';
import 'package:quote_vault/features/search/view/widgets/quote_result_card.dart';
import 'package:quote_vault/features/search/view/widgets/search_header.dart';

@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          const BackgroundLayer(),

          // Main Content
          CustomScrollView(
            slivers: [
              // Spacer for Sticky Header (approx height of header + padding)
              const SliverToBoxAdapter(
                child: SizedBox(height: 190),
              ),

              // Quote Results Header
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'QUOTES',
                        style: AppTextStyles.display.copyWith(
                          fontSize: 12, // text-sm
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade400,
                          letterSpacing: 1.0, // tracking-wider
                        ),
                      ),
                      Text(
                        '12 results',
                        style: AppTextStyles.display.copyWith(
                          fontSize: 12, // text-xs
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Quote Result List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.separated(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final quotes = [
                      "By three methods we may learn wisdom: First, by reflection, which is noblest; Second, by imitation, which is easiest; and third by experience, which is the bitterest.",
                      "The man who asks a question is a fool for a minute, the man who does not ask is a fool for life.",
                      "Real knowledge is to know the extent of one's ignorance."
                    ];
                    return QuoteResultCard(
                      text: quotes[index],
                      author: "Confucius",
                    );
                  },
                  separatorBuilder: (c, i) => const SizedBox(height: 16),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // Authors Header
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'AUTHORS',
                    style: AppTextStyles.display.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),

              // Authors List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: const AuthorResultTile(
                    name: 'Confucius',
                    description: 'Chinese philosopher and politician',
                    initial: 'C',
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom nav spacer
            ],
          ),

          // Sticky Header
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SearchHeader(),
          ),

          // // Bottom Nav
          // const Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: CustomBottomNavBar(),
          // ),
        ],
      ),
    );
  }
}
