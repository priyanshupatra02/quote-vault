import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

@RoutePage()
class ResetPasswordSuccessPage extends StatelessWidget {
  const ResetPasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity, // Ensure full height for layout
          child: Stack(
            children: [
              // Main Centered Content
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Status Icon with Glow
                        Container(
                          width: 112, // 28 * 4
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.2),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: -10,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 64,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Title
                        Text(
                          'Reset link sent!',
                          style: AppTextStyles.headline1.copyWith(
                            fontSize: 30, // ~3xl
                            fontWeight: FontWeight.bold,
                            color: AppColors.text(context),
                            height: 1.2,
                            letterSpacing: -0.015,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),

                        // Description
                        Text(
                          'Check your inbox for further instructions to create a new password.',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16,
                            color: AppColors.textSecondary(context),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer Actions (Pinned to bottom)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 480),
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Primary Action
                        SizedBox(
                          width: double.infinity,
                          height: 56, // h-14
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to Login (or root for now)
                              // context.router.replaceAll([const LoginRoute()]);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: const Color(0xFF231e0f), // Dark text on yellow
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // rounded-xl
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Return to Login',
                              style: AppTextStyles.buttonText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF231e0f), // Ensure contrast
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Secondary Action
                        TextButton(
                          onPressed: () {
                            // Resend logic
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: AppColors.textSecondary(context),
                            minimumSize: const Size(84, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.body.copyWith(
                                fontSize: 14,
                                color: AppColors.textSecondary(context),
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                const TextSpan(text: "Didn't receive an email? "),
                                TextSpan(
                                  text: 'Resend',
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 14,
                                    color: AppColors.text(context),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primary.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
