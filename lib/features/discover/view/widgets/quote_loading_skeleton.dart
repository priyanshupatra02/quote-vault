import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:shimmer/shimmer.dart';

class QuoteLoadingSkeleton extends StatelessWidget {
  const QuoteLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Shimmer base/highlight matching tailwind pulse feel
    // Tailwind bg-white/10 -> roughly white10
    final baseColor = Colors.white.withOpacity(0.1);
    final highlightColor = Colors.white.withOpacity(0.05);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            // Top Spinner & "Refreshing" text simulation
            // Ideally we might keep the spinner distinct from shimmer if it spins,
            // but for a pure skeleton view, we can just simulate the structure or omit.
            // The HTML has a real spinner. Let's add a real spinner above the shimmer if needed.
            // Implemeting the main quote skeleton as per HTML "mb-10 w-full animate-pulse space-y-4"

            // Quote Mark
            Align(
              alignment: Alignment.centerLeft,
              child: Opacity(
                opacity: 0.1,
                child: Text(
                  '“',
                  style: AppTextStyles.serif(context).copyWith(
                    fontSize: 60,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Line 1 (Width full)
            Container(
              width: double.infinity,
              height: 36, // h-9
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 16), // space-y-4

            // Line 2 (Width 92%)
            FractionallySizedBox(
              widthFactor: 0.92,
              alignment: Alignment.centerLeft,
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Line 3 (Width 60%)
            FractionallySizedBox(
              widthFactor: 0.6,
              alignment: Alignment.centerLeft,
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 40), // mb-10 equivalent spacing

            // Author Section
            Row(
              children: [
                Container(
                  width: 32,
                  height: 1,
                  color: AppColors.primary.withOpacity(0.3), // bg-primary/30
                ),
                const SizedBox(width: 12),
                Container(
                  width: 128, // w-32
                  height: 16, // h-4
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
