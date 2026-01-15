import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Spacer to balance the center title (width 40 approx)
          const SizedBox(width: 40),

          Text(
            'Explore',
            style: AppTextStyles.display.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context), // dark mode text
              letterSpacing: -0.015,
            ),
          ),

          // Profile Picture
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary, Color(0xFFC084FC)], // primary to purple-400
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background(context), width: 2),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuA5J-CWuVedgp8JVY6b2LWvz_VcyA5t6qijftY3OZbyaTQcpziTd5rkxnYGzN_NsnDhqpx7Dx63lwUI7ev3WbV4pKu_zOJfJ5efKG9Ownu3GSL4fisFjRFgDk6Kj_woUGSxH9UmbvQ5DhkV3eE3uUTgYLoyTl-WPYF2_smVFnuoz7RDJ9GrqbBCIhxqf9J9GeLTCB6VV1QQ50yjfeLqg76DO7rkCun2yn_xzOtXqPmQmzQj1y8SFgtI63U20JLiEk1wtlxh-DEivI0',
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
