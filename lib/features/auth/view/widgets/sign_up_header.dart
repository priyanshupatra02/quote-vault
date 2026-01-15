import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                AppColors.primary,
                Colors.purple.shade400,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.format_quote,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'QuoteVault',
          style: AppTextStyles.serif.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.text(context),
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Start collecting your wisdom today.',
          textAlign: TextAlign.center,
          style: AppTextStyles.display.copyWith(
            fontSize: 16,
            color: AppColors.text(context).withOpacity(0.6),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
