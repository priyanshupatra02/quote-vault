import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/discover/view/widgets/background_layer.dart';
import 'package:quote_vault/features/discover/view/widgets/custom_bottom_nav_bar.dart';
import 'package:quote_vault/features/explore/view/widgets/explore_header.dart';
import 'package:quote_vault/features/explore/view/widgets/explore_search_bar.dart';
import 'package:quote_vault/features/explore/view/widgets/featured_authors_list.dart';
import 'package:quote_vault/features/explore/view/widgets/topic_image_card.dart';

@RoutePage()
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundLayer(),
          SafeArea(
            child: Column(
              children: [
                const ExploreHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100), // padding for bottom nav
                    children: [
                      // Sticky Search Bar container
                      // In a real Slivers implementation this would pin,
                      // but for ListView we'll just place it at top of scroll or strictly layout.
                      // Design shows it under header.
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ExploreSearchBar(),
                      ),
                      const SizedBox(height: 24),

                      // Topics Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Topics & Moods',
                              style: AppTextStyles.display.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.015,
                              ),
                            ),
                            Text(
                              'See All',
                              style: AppTextStyles.display.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Topic Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 4 / 3,
                          children: const [
                            TopicImageCard(
                              title: 'Mindfulness',
                              subtitle: '1.2k Quotes',
                              icon: Icons.spa,
                              accentColor: Colors.teal,
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCsbtQqX4E-1vZnpGbkz6ZARZ90Fx92ObglZ0fuIVLdQpiiJ_bAyOJ-Xc30bCqPcEjdDLnEajApFeWZ3cSTq69ow6-RwxdKFRibQjJIGIr8CRX5Zj-Y3kRFy_oFZvDHiZcjtFp2w2pnuKnxw-onG1f5Q9tDK4mqYfaWec9He4XObmK3xdSliv9ePaqVibisMNdldCBZvoTolTNuBImONRLxjeS25VaTHmNGNwEZzPDlqUqCqI_x2_W3uY4mkrZFBmSStXBSniGCseU',
                            ),
                            TopicImageCard(
                              title: 'Resilience',
                              subtitle: '850 Quotes',
                              icon: Icons.landscape,
                              accentColor: Colors.blue,
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCcx3MrEq7GOTDwAVZTOw85EaXYHAfielc8-tKrE-cIpydB13uqrGUp4S6n63Tdh7sIdPzUCF45rAYrIqQHExpqSy9OYDttMiptThVImwkn31Y9cgMzZLVQVKe3auK9VfJxCcGfClQpI1gObedy9cwmTr018hzFBkybYUNHahF2QJFsvuD4CXyRwzAEBrLA7Qhz3rl5MCatcrHXB0GQTl6ciD0RRGZehwC8ljg4Aj_gzlFabJpAX1D9ewD6_Ceng7KGaTWd-55587k',
                            ),
                            TopicImageCard(
                              title: 'Success',
                              subtitle: '2.4k Quotes',
                              icon: Icons.trending_up,
                              accentColor: Colors.amber,
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCrPeBtrqGzgUb0oG_FFnk4d7Z51GYbhaX8Bxvk6Gl3SB-I4Z0porLJCLOi3EnG8_MKDm-HOmguhRco8LcajMvoT1zcE_rpMP_ViQobDZAtDmuinIKg6rVyBs674b4NY-8r2UgfSjVrmZVjwyY93uAbAmKgMRop_zoF978ZDPHqNOXvhuh5E6ZE3ZpRYOo01Iw_RSHkBCQPeeSd3ktboJO_B7tT7oh4o1ZQy0jKGQE6KzwQ17srhjcutziKEbEI7zycQ84k1SiuNSc',
                            ),
                            TopicImageCard(
                              title: 'Love',
                              subtitle: '3.1k Quotes',
                              icon: Icons.favorite,
                              accentColor: Colors.pink, // rose-900 like
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCTmm891DTkGJxfx0yE4WlZiUDw4_SN3x-Ll5fcn-TjoBtWLky6aPar_NJ4BSYO9AccGCWomGS20lUC_fefREi3k78Y4ZdYAB1zu_uw761NWWfN7nn_ZVwoDkZkvb9gyX6buDYbOnaWSZNV65YDTtEMgeeYahtvXIzlVDLADKMRluSPeuzYvhwP1pnHQNKg19HJKgzYLbRSNfzExNEGvxp9pFWZyEBvGh3Geb5UviWp4MNezknElXAt2wJX2tPLnQU_YTZxO8VOGvM',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      Divider(color: Colors.white.withOpacity(0.05), indent: 16, endIndent: 16),
                      const SizedBox(height: 16),

                      const FeaturedAuthorsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
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
