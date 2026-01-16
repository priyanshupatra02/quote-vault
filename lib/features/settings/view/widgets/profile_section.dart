import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/auth/controller/auth_controller.dart';
import 'package:quote_vault/features/settings/view/widgets/avatar_selection_sheet.dart';
import 'package:quote_vault/shared/riverpod_ext/asynvalue_easy_when.dart';

class ProfileSection extends ConsumerWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(authControllerProvider);

    return userAsync.easyWhen(
      data: (user) {
        final email = user?.email ?? 'User';
        // Try to get name from metadata (full_name for OAuth, name for manual signup), fallback to email prefix
        final metadata = user?.userMetadata;
        String name = metadata?['full_name'] ??
            metadata?['name'] ??
            email.split('@')[0].split('.').map((e) => e.capitalize()).join(' ');

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const AvatarSelectionSheet(),
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.2), // Fallback color
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      // Use metadata avatar if available, else a placeholder or initals
                      image: user?.userMetadata?['avatar_url'] != null
                          ? DecorationImage(
                              image: NetworkImage(user!.userMetadata!['avatar_url']),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: user?.userMetadata?['avatar_url'] == null
                        ? Center(
                            child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                style: TextStyle(
                                    fontSize: 40,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)))
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.grey[900]! : Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: AppTextStyles.display(context).copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text(context),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'FREE', // Or check subscription status if available
                    style: AppTextStyles.label(context).copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: AppTextStyles.body(context).copyWith(
                fontSize: 14,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
