import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/auth/view/widgets/auth_input_fields.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel(label: 'Email'),
        AuthTextField(
          controller: _emailController,
          hintText: 'hello@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        const AuthLabel(label: 'Password'),
        AuthTextField(
          controller: _passwordController,
          hintText: 'Enter your password',
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
                'Forgot Password?',
                style: AppTextStyles.body.copyWith(
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
            onPressed: () {
              // TODO: Implement Login Logic
              // Navigate to Home/Settings on success
              // context.router.replace(const SettingsRoute());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Log In',
              style: AppTextStyles.buttonText.copyWith(
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
