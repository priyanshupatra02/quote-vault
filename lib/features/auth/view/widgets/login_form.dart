import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/constants/app_strings.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/auth/controller/pod/auth_pod.dart';
import 'package:quote_vault/features/auth/controller/state/auth_states.dart';
import 'package:quote_vault/features/auth/view/widgets/auth_input_fields.dart';
import 'package:quote_vault/shared/widget/custom_loaders/app_loader.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.formErrorMissingFields)),
      );
      return;
    }

    await ref.read(authStateProvider.notifier).signIn(
          email: email,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // Listen for state changes and react accordingly
    ref.listen<AsyncValue<AuthState>>(authStateProvider, (previous, next) {
      next.whenData((state) {
        if (state is AuthenticatedState) {
          context.router.replace(const NavbarRoute());
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.loginFailedPrefix}${state.message}')),
          );
        }
      });
    });

    final isLoading = authState.whenOrNull(
          data: (state) => state is AuthLoadingState,
        ) ??
        authState.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel(label: AppStrings.emailLabel),
        AuthTextField(
          controller: _emailController,
          hintText: AppStrings.emailHint,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        const AuthLabel(label: AppStrings.passwordLabel),
        AuthTextField(
          controller: _passwordController,
          hintText: AppStrings.passwordHint,
          obscureText: _obscurePassword,
          isPassword: true,
          onToggleVisibility: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),

        // Forgot Password Link
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: GestureDetector(
              onTap: () {
                context.router.push(const ForgotPasswordRoute());
              },
              child: Text(
                AppStrings.forgotPassword,
                style: AppTextStyles.body(context).copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),

        // Login Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: AppLoader(progressColor: Colors.white),
                  )
                : Text(
                    AppStrings.signInButton,
                    style: AppTextStyles.buttonText(context).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
