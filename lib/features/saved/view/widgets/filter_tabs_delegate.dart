import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/saved/controller/pod/saved_page_providers.dart';

class FilterTabsDelegate extends SliverPersistentHeaderDelegate {
  final VaultFilter selectedFilter;
  final ValueChanged<VaultFilter> onFilterChanged;
  final bool isDark;

  FilterTabsDelegate({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFFCFCFD),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: VaultFilter.values.map((filter) {
            final isSelected = selectedFilter == filter;
            return Expanded(
              child: GestureDetector(
                onTap: () => onFilterChanged(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? Colors.white.withOpacity(0.1) : Colors.white)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected && !isDark
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      filter.name[0].toUpperCase() + filter.name.substring(1),
                      style: isSelected
                          ? AppTextStyles.navLabelActive(context).copyWith(
                              fontSize: 14,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            )
                          : AppTextStyles.navLabelInactive(context).copyWith(
                              fontSize: 14,
                              color: isDark ? Colors.white38 : Colors.grey[500],
                            ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant FilterTabsDelegate oldDelegate) =>
      selectedFilter != oldDelegate.selectedFilter || isDark != oldDelegate.isDark;
}
