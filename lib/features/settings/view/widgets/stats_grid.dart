import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/collections/controller/pod/collections_pod.dart';
import 'package:quote_vault/features/collections/controller/state/collections_states.dart';
import 'package:quote_vault/features/favorites/controller/pod/favorites_pod.dart';
import 'package:quote_vault/features/favorites/controller/state/favorites_states.dart';

class StatsGrid extends ConsumerWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final collectionsState = ref.watch(collectionsProvider);

    int favoritesCount = 0;
    favoritesState.whenData((state) {
      if (state is FavoritesLoadedState) {
        favoritesCount = state.favorites.length;
      }
    });

    int collectionsCount = 0;
    collectionsState.whenData((state) {
      if (state is CollectionsLoadedState) {
        collectionsCount = state.collections.length;
      }
    });

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.folder,
            iconColor: Colors.orange,
            badgeText: 'Active',
            value: collectionsCount.toString(),
            label: 'Collections',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.favorite,
            iconColor: AppColors.primary,
            badgeText: 'Total',
            value: favoritesCount.toString(),
            label: 'Quotes Saved',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String badgeText;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.badgeText,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF2F2F7), // ios-card color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  badgeText,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669), // Emerald 600
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.display.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
              letterSpacing: -0.5,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
