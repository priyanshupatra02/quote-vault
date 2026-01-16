import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/auth/controller/pod/auth_pod.dart';
import 'package:quote_vault/features/auth/controller/state/auth_states.dart';

@RoutePage()
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    await ref.read(authStateProvider.notifier).resetPassword(email: email);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authStateProvider);

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

    final isLoading = authState.whenOrNull(
          data: (state) => state is AuthLoadingState,
        ) ??
        authState.isLoading;

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Hero Icon (Lock)
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(isDark ? 0.2 : 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.lock,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Header
                      Text(
                        'Reset Password',
                        style: AppTextStyles.headline1.copyWith(
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
                        style: AppTextStyles.body.copyWith(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : AppColors.text(context).withOpacity(0.8),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Form
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              'Email Address',
                              style: AppTextStyles.label.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.text(context),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                if (!isDark)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.text(context),
                              ),
                              decoration: InputDecoration(
                                hintText: 'john.doe@example.com',
                                hintStyle: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary(context),
                                ),
                                filled: true,
                                fillColor: AppColors.surface(context),
                                suffixIcon: Icon(
                                  Icons.mail_outline,
                                  color: AppColors.textSecondary(context),
                                  size: 20,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleResetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      'Send Reset Link',
                                      style: AppTextStyles.buttonText.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remember your password?',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.router.replace(const LoginRoute());
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Log in',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
