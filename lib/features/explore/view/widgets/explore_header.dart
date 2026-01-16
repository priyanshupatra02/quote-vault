import 'package:flutter/material.dart';
import 'package:quote_vault/core/constants/app_strings.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/explore/view/widgets/explore_search_bar.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        // Light: High opacity white. Dark: Low opacity black/transparent to show nebula.
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.transparent
            : Colors.white.withOpacity(0.95),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                AppStrings.exploreTitle,
                style: AppTextStyles.pageTitle(context).copyWith(
                  color: AppColors.text(context),
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              const ExploreSearchBar(),
            ],
          ),
        ),
      ),
    );
  }
}
