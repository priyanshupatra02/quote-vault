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
          _buildItem(context, Icons.text_fields, 'Type', true),
          _buildItem(context, Icons.wallpaper, 'Back', false),
          _buildItem(context, Icons.auto_awesome, 'Effects', false),
          _buildItem(context, Icons.grid_view, 'Layout', false),
          _buildItem(context, Icons.person, 'Author', false),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String label, bool isActive) {
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
