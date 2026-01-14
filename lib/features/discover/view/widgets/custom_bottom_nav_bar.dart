import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84, // css: h-[84px]
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withOpacity(0.8),
        border: const Border(
          top: BorderSide(
            color: Colors.white12, // white/5 like css
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16), // backdrop-blur-xl
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavItem(
                  icon: Icons.style,
                  label: 'Discover',
                  isActive: true,
                ),
                _buildNavItem(
                  icon: Icons.search,
                  label: 'Search',
                  isActive: false,
                ),
                _buildNavItem(
                  icon: Icons.person,
                  label: 'Profile',
                  isActive: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(999),
                )
              : null,
          child: Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.white60,
            size: 26,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bottomNavText.copyWith(
            color: isActive ? AppColors.primary : Colors.white60,
          ),
        ),
      ],
    );
  }
}
