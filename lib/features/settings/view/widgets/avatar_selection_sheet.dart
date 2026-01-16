import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/auth/controller/auth_controller.dart';
import 'package:quote_vault/features/settings/controller/avatar_provider.dart';
import 'package:quote_vault/shared/widget/custom_loaders/app_loader.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarSelectionSheet extends ConsumerWidget {
  const AvatarSelectionSheet({super.key});

  Future<void> _selectAvatar(BuildContext context, WidgetRef ref, String fileName) async {
    final publicUrl =
        Supabase.instance.client.storage.from('avatars').getPublicUrl('premade/$fileName');

    await ref.read(authControllerProvider.notifier).updateAvatar(publicUrl);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarsAsync = ref.watch(avatarListProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Choose an Avatar',
            style: AppTextStyles.display(context).copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
            ),
          ),
          const SizedBox(height: 20),
          avatarsAsync.when(
            data: (avatars) {
              if (avatars.isEmpty) {
                return Center(
                  child: Text(
                    'No avatars found',
                    style: AppTextStyles.body(context).copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: avatars.length,
                itemBuilder: (context, index) {
                  final file = avatars[index];
                  final imageUrl = Supabase.instance.client.storage
                      .from('avatars')
                      .getPublicUrl('premade/${file.name}');

                  return GestureDetector(
                    onTap: () => _selectAvatar(context, ref, file.name),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.black12,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: AppLoader()),
            error: (e, stack) => Center(child: Text('Error: $e')),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
