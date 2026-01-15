import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/auth/view/widgets/auth_input_fields.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthLabel(label: 'Full Name'),
        const SizedBox(height: 6),
        AuthTextField(
          controller: _nameController,
          hintText: 'John Doe',
        ),
        const SizedBox(height: 16),
        const AuthLabel(label: 'Email'),
        const SizedBox(height: 6),
        AuthTextField(
          controller: _emailController,
          hintText: 'hello@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        const AuthLabel(label: 'Password'),
        const SizedBox(height: 6),
        AuthTextField(
          controller: _passwordController,
          hintText: 'Create a password',
          obscureText: _obscurePassword,
          isPassword: true,
          onToggleVisibility: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              'Forgot Password?',
              style: AppTextStyles.display.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AppColors.primary.withOpacity(0.4),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Create Account',
            style: AppTextStyles.display.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
