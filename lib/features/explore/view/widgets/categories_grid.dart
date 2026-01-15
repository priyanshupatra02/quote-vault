import 'package:flutter/material.dart';
import 'package:quote_vault/features/explore/view/widgets/category_card.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6), // mt-6
          Text(
            'BROWSE BY CATEGORY',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 0.15 * 12, // tracking-[0.15em]
            ),
          ),
          const SizedBox(height: 16),

          // Grid Layout
          // Row 1
          const Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 144, // h-36 = 144px
                  child: CategoryCard(
                    title: 'Motivation',
                    subtitle: '2.4k Quotes',
                    icon: Icons.bolt,
                    accentColor: Colors.purpleAccent, // purple-300ish
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 144,
                  child: CategoryCard(
                    title: 'Love',
                    subtitle: '1.8k Quotes',
                    icon: Icons.favorite,
                    accentColor: Colors.redAccent, // rose-300
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 2
          const Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 144,
                  child: CategoryCard(
                    title: 'Success',
                    subtitle: '3.1k Quotes',
                    icon: Icons.trending_up,
                    accentColor: Colors.tealAccent, // emerald-300
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 144,
                  child: CategoryCard(
                    title: 'Wisdom',
                    subtitle: '1.2k Quotes',
                    icon: Icons.lightbulb,
                    accentColor: Colors.amberAccent, // amber-300
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Wide Card
          const SizedBox(
            height: 112, // h-28 = 112px
            child: CategoryCard(
              title: 'Humor',
              subtitle: 'Lighten your day',
              icon: Icons.sentiment_very_satisfied,
              accentColor: Colors.pinkAccent,
              isWide: true,
            ),
          ),

          const SizedBox(height: 24), // bottom pad
        ],
      ),
    );
  }
}
