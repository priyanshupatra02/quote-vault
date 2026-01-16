import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/settings/controller/user_stats_provider.dart';

class StatsGrid extends ConsumerWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(userStatsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final streak = statsState.value?.loginStreak ?? 0;
    final shares = statsState.value?.shareCount ?? 0;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: Colors.orange,
            badgeText: '+1 day',
            value: '$streak Days',
            label: 'Current Streak',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.format_quote_rounded,
            iconColor: Colors.deepPurpleAccent,
            badgeText: '+1', // Simplified as we don't track daily share delta yet
            value: '$shares',
            label: 'Quotes Shared',
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String? badgeText;
  final String value;
  final String label;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    this.badgeText,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 28),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Text(
                    badgeText!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF059669), // Emerald 600
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            value,
            style: AppTextStyles.display.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.text(context),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
