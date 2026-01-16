import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        const SizedBox(height: 20),
        // Hero Icon (Lock)
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(isDark ? 0.2 : 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryColor.withOpacity(isDark ? 0.1 : 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.lock,
            size: 40,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 32),

        // Header
        Text(
          'Reset Password',
          style: AppTextStyles.headline1(context).copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.text(context),
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Enter your email address and we will send you a link to reset your password.',
          style: AppTextStyles.body(context).copyWith(
            fontSize: 16,
            color: isDark ? Colors.white70 : AppColors.text(context).withOpacity(0.8),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
