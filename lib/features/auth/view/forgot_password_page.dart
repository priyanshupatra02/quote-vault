import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/features/auth/controller/pod/auth_pod.dart';
import 'package:quote_vault/features/auth/controller/state/auth_states.dart';
import 'package:quote_vault/features/auth/view/widgets/back_to_login_link.dart';
import 'package:quote_vault/features/auth/view/widgets/forgot_password_form.dart';
import 'package:quote_vault/features/auth/view/widgets/forgot_password_header.dart';

@RoutePage()
class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen for state changes
    ref.listen<AsyncValue<AuthState>>(authStateProvider, (previous, next) {
      next.whenData((state) {
        if (state is PasswordResetSentState) {
          context.router.replace(const ResetPasswordSuccessRoute());
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  InkWell(
                    onTap: () => context.router.back(),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: AppColors.text(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance spacer
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 448), // max-w-md
                  width: double.infinity,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ForgotPasswordHeader(),
                      SizedBox(height: 32),
                      ForgotPasswordForm(),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: BackToLoginLink(),
            ),
          ],
        ),
      ),
    );
  }
}
