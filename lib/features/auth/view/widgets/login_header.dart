import 'package:flutter/material.dart';
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
                const Color(0xFF6B18D8), // Deep purple
                const Color(0xFF904BE6), // Lighter purple
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B18D8).withOpacity(0.4),
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
          'QuoteVault',
          style: AppTextStyles.serif.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.text(context),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),

        // Tagline / Welcome Back
        Text(
          'Welcome back! Continue your journey.',
          style: AppTextStyles.body.copyWith(
            fontSize: 16,
            color: AppColors.textSecondary(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
