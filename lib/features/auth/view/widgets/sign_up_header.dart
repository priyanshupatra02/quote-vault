import 'package:flutter/material.dart';
import 'package:quote_vault/core/constants/app_strings.dart';
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
                Theme.of(context).primaryColor,
                Colors.purple
                    .shade400, // Kept purple as secondary gradient for brand identity or change?
                // Let's stick to primaryColor and a variant for now to respect choice
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
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
          AppStrings.appName,
          style: AppTextStyles.serif(context).copyWith(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.text(context),
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.signUpSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.display(context).copyWith(
            fontSize: 16,
            color: AppColors.text(context).withOpacity(0.6),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
