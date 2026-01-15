import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class EditorToolbar extends StatelessWidget {
  const EditorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1F1C26).withOpacity(0.5)
          : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _EditorToolbarItem(
            icon: Icons.text_fields,
            label: 'Type',
            isActive: true,
          ),
          const _EditorToolbarItem(
            icon: Icons.wallpaper,
            label: 'Back',
            isActive: false,
          ),
          const _EditorToolbarItem(
            icon: Icons.auto_awesome,
            label: 'Effects',
            isActive: false,
          ),
          const _EditorToolbarItem(
            icon: Icons.grid_view,
            label: 'Layout',
            isActive: false,
          ),
          const _EditorToolbarItem(
            icon: Icons.person,
            label: 'Author',
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _EditorToolbarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _EditorToolbarItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 26,
          color: isActive ? AppColors.primary : AppColors.textSecondary(context),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.display.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isActive ? AppColors.primary : Colors.transparent, // Simulate opacity toggle
          ),
        ),
      ],
    );
  }
}
