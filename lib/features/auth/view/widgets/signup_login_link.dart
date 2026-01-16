import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class SignupLoginLink extends StatelessWidget {
  const SignupLoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already a member? ',
          style: AppTextStyles.display(context).copyWith(
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
