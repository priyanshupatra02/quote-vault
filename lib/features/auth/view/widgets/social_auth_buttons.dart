import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    final buttonBg = isDark ? const Color(0xFF1f1a2e) : Colors.white;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(color: borderColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Or continue with',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: borderColor),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                icon: _GoogleIcon(),
                label: 'Google',
                bgColor: buttonBg,
                borderColor: borderColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SocialButton(
                icon: _XIcon(color: AppColors.text(context)),
                label: 'X',
                bgColor: buttonBg,
                borderColor: borderColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color bgColor;
  final Color borderColor;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20, height: 20, child: icon),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.display.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.text(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/google_logo.svg',
      width: 24,
      height: 24,
    );
  }
}

class _XIcon extends StatelessWidget {
  final Color color;
  const _XIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/x_logo.svg',
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
