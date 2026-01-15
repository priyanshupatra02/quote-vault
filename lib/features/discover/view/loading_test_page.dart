import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/features/discover/view/widgets/background_layer.dart';
import 'package:quote_vault/features/discover/view/widgets/custom_bottom_nav_bar.dart';
import 'package:quote_vault/features/discover/view/widgets/quote_loading_skeleton.dart';

@RoutePage()
class LoadingTestPage extends StatelessWidget {
  const LoadingTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundLayer(),

          SafeArea(
            child: Column(
              children: [
                // Top "Refreshing" spinner as per HTML
                Padding(
                  padding: const EdgeInsets.only(top: 48, bottom: 16),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'REFRESHING...',
                        style: TextStyle(
                          color: AppColors.primary.withOpacity(0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: const QuoteLoadingSkeleton(),
                  ),
                ),

                // Fake Action Sidebar (Loading state)
                // Just visual placeholder for verification
              ],
            ),
          ),

          // Action Sidebar Loading State (Mock)
          Positioned(
            bottom: 112,
            right: 20,
            child: Column(
              children: [
                _buildLoadingButton(),
                const SizedBox(height: 24),
                _buildLoadingButton(),
                const SizedBox(height: 24),
                _buildLoadingButton(),
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

  Widget _buildLoadingButton() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
