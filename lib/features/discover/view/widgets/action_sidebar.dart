import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';

class ActionSidebar extends StatelessWidget {
  const ActionSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SidebarActionButton(
          icon: Icons.favorite_border,
          label: '12.4k',
          isLiked: false,
        ),
        SizedBox(height: 20),
        SidebarActionButton(
          icon: Icons.bookmark_border,
          label: 'Save',
        ),
        SizedBox(height: 20),
        SidebarActionButton(
          icon: Icons.ios_share,
          label: 'Share',
        ),
      ],
    );
  }
}

class SidebarActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLiked;

  const SidebarActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = AppColors.text(context);

    // Light mode: white/40 bg with backdrop blur (from HTML)
    // Dark mode: white/5 bg with backdrop blur
    final containerColor = isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.4);
    final borderColor = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: containerColor,
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Center(
                child: Icon(
                  isLiked ? Icons.favorite : icon,
                  color: isLiked ? Colors.red[400] : iconColor,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary(context).withOpacity(isDark ? 0.6 : 0.5),
          ),
        ),
      ],
    );
  }
}
