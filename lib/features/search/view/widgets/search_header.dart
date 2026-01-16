import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/search/view/widgets/filter_chips_row.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withOpacity(0.95),
            border: const Border(
              bottom: BorderSide(
                color: Colors.white12, // white/5 matches design
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 48, // approximate safe area
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Back Button + Title
              Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.router.back(),
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white.withOpacity(0.7),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Search Results',
                    style: AppTextStyles.display(context).copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Input Field
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey.shade400, // text-gray-400
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Wisdom', // Mock value "Wisdom"
                        style: AppTextStyles.display(context).copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.close,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              const FilterChipsRow(),
            ],
          ),
        ),
      ),
    );
  }
}
