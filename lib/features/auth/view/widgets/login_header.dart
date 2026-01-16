import 'package:flutter/material.dart';
import 'package:quote_vault/core/constants/app_strings.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Logo
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.format_quote_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),

        // App Name
        Text(
          AppStrings.appName,
          style: AppTextStyles.serif(context).copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.text(context),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),

        // Tagline / Welcome Back
        Text(
          AppStrings.loginSubtitle,
          style: AppTextStyles.body(context).copyWith(
            fontSize: 16,
            color: AppColors.textSecondary(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
