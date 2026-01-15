import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/discover/view/widgets/background_layer.dart';
import 'package:quote_vault/features/discover/view/widgets/custom_bottom_nav_bar.dart';
import 'package:quote_vault/features/saved/view/widgets/collection_card.dart';

@RoutePage()
class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundLayer(),

          SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  backgroundColor: isDark
                      ? AppColors.backgroundDark.withOpacity(0.9)
                      : AppColors.backgroundLight.withOpacity(0.9),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  expandedHeight: 100,
                  toolbarHeight: 80,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'My Collections',
                          style: AppTextStyles.display.copyWith(
                            fontSize: 24, // Slight adjustment for Sliver title scaling
                            fontWeight: FontWeight.w800,
                            color: AppColors.text(context),
                            letterSpacing: -0.5,
                          ),
                        ),
                        // Subtitle tricky in SliverAppBar title, usually done in bottom widget or custom.
                        // For simplicity in standard SliverAppBar, we can mimic or just use simple text.
                        // Let's rely on standard title and put subtitle in row or just stick to Title for now to match Sliver behavior.
                        // Actually, HTML has "Sticky top... pt-12 pb-4".
                        // Standard SliverAppBar is good enough.
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, bottom: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '48 saved quotes',
                          style: AppTextStyles.display.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    SliverGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8, // Aspect ratio 4/5
                      children: [
                        // Card 1: Morning Motivation
                        CollectionCard(
                          title: 'Morning Motivation',
                          count: '15',
                          type: CollectionCardType.gradient,
                          gradientColors: [AppColors.primary, Colors.purpleAccent],
                          contentPreview: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: 'Wake up\n'),
                                TextSpan(text: 'and win'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.display.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [AppColors.primary, Colors.purpleAccent],
                                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                            ),
                          ),
                        ),

                        // Card 2: Work Wisdom
                        CollectionCard(
                          title: 'Work Wisdom',
                          count: '8',
                          type: CollectionCardType.image,
                          imageUrl:
                              'https://images.unsplash.com/photo-1497215728101-856f4ea42174?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Office desk
                          contentPreview: Text(
                            'Aa',
                            style: AppTextStyles.serif.copyWith(
                              fontSize: 48,
                              fontStyle: FontStyle.italic,
                              color: AppColors.text(context),
                            ),
                          ),
                        ),

                        // Card 3: Stoicism
                        CollectionCard(
                          title: 'Stoicism',
                          count: '24',
                          // Using solid dark bg simulation via image or gradient?
                          // HTML uses bg-surface-dark. Let's use gradient overlay in card logic or solid card.
                          // Let's use solid card with dark color for this semantic match.
                          solidColor: const Color(0xFF231e30),
                          type: CollectionCardType.solid,
                          contentPreview: Text(
                            '"Amor\nFati"',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.serif.copyWith(
                              fontSize: 24,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),

                        // Card 4: Funny
                        CollectionCard(
                          title: 'Funny',
                          count: '4',
                          type: CollectionCardType.solid,
                          solidColor: const Color(0xFFffeb3b),
                          contentPreview: Transform.rotate(
                            angle: 0.2,
                            child: const Text(
                              'HA\nHA',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),

                        // Card 5: Life Lessons
                        CollectionCard(
                          title: 'Life Lessons',
                          count: '1',
                          type: CollectionCardType.gradient,
                          gradientColors: [Colors.blue, AppColors.primary],
                          contentPreview: Text(
                            ';-)',
                            style: TextStyle(
                              fontSize: 36,
                              fontFamily: 'Courier',
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),
          ),

          // FAB
          Positioned(
            bottom: 100, // Above nav
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                context.router.push(const EditorRoute()); // Or create collection
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
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
