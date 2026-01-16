import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FooterButton(label: 'Rate App', onTap: () {}),
            const SizedBox(width: 24),
            _FooterButton(label: 'Support', onTap: () {}),
            const SizedBox(width: 24),
            _FooterButton(label: 'Privacy', onTap: () {}),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'QuoteVault v1.0.2',
          style: AppTextStyles.label(context).copyWith(
            color: AppColors.textSecondary(context),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _FooterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.display(context).copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary(context), // Starts gray
        ),
        // Hover handling is simpler on web, for mobile a simple press effect or color
        // The detailed behavior: hover:text-primary.
      ),
    );
  }
}
