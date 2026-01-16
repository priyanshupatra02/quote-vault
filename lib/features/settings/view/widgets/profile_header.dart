import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with edit badge
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white,
                    width: 4), // dark:ring-surface-dark ignored for now as likely dark bg
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCjq4H557LPqOHhcWdBbRu8an52o6Ur7CB6hr0SZu2GP1q8sY4YOzX5G-COHU_OJiVnrmGOf9ORZRa5I155WQxkuKbCKO0KD3H1j0ZhX5nmuuE697rrpshVnEw0AuEvdBSnG_mFqfNokpepej1BNhT9G5dntQHI9EjmX8zEeDfUqB9HGJZMM4vgGRBKcW897TzDlFugkf0yjtAc-2bxjBA8biXoaKzoE7lKORxgzDQJlKRakMuYg8TwF9U71nsbkmcckRFj5Hanm98',
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.grey.shade800),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4, right: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border:
                    Border.all(color: const Color(0xFF161121), width: 3), // background-dark border
              ),
              child: const Icon(
                Icons.edit,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Name & Badge
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Alex Sterling',
              style: AppTextStyles.display(context).copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text(context),
                letterSpacing: -0.015,
                height: 1.1,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'PRO',
                style: AppTextStyles.display(context).copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Member since 2023 • alex.sterling@example.com',
          style: AppTextStyles.display(context).copyWith(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.textSecondary(context), // #a69db8
          ),
        ),
      ],
    );
  }
}
