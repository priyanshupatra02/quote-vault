import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class LoginSignupLink extends StatelessWidget {
  const LoginSignupLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.display(context).copyWith(
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
            style: AppTextStyles.display(context).copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
