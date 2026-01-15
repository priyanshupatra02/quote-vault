import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class SignUpLink extends StatelessWidget {
  const SignUpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.display.copyWith(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.router.replace(const SignUpRoute());
          },
          child: Text(
            'Sign Up',
            style: AppTextStyles.display.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already a member? ',
          style: AppTextStyles.display.copyWith(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.router.replace(const LoginRoute());
          },
          child: Text(
            'Log In',
            style: AppTextStyles.display.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
