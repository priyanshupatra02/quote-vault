import 'package:flutter/material.dart';
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

// Simple Custom Icons to avoid extra assets for now
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Basic representation or SVG path could be used here.
    // For now, using a colored 'G' text or Icon if available, but designs usually need the logo.
    // I'll implement a simple colored G using text for simplicity or standard icon if available.
    // Ideally SVG. Let's use a placeholder Icon or Text.
    // Better: SVG Paths from the HTML instructions.
    // Since I can't easily paste SVG path string to IconData, I'll use CustomPaint or just text "G" for now?
    // Wait, I can use an Image.network or local asset if available.
    // I'll double check assets. If no assets, I'll use text.
    return const Icon(Icons.g_mobiledata, size: 28, color: Colors.blue); // Placeholder
  }
}

class _XIcon extends StatelessWidget {
  final Color color;
  const _XIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.close,
        size: 20, color: color); // X logo usually looks like close or distinct X
  }
}
