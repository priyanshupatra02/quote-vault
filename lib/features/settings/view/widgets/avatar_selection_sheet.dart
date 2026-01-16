import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/auth/controller/auth_controller.dart';
import 'package:quote_vault/shared/widget/custom_loaders/app_loader.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarSelectionSheet extends ConsumerStatefulWidget {
  const AvatarSelectionSheet({super.key});

  @override
  ConsumerState<AvatarSelectionSheet> createState() => _AvatarSelectionSheetState();
}

class _AvatarSelectionSheetState extends ConsumerState<AvatarSelectionSheet> {
  List<FileObject> _avatars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAvatars();
  }

  Future<void> _fetchAvatars() async {
    try {
      final avatars = await Supabase.instance.client.storage.from('avatars').list(path: 'premade');

      setState(() {
        _avatars = avatars.where((file) => file.name.endsWith('.png')).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load avatars: $e')),
        );
      }
    }
  }

  Future<void> _selectAvatar(String fileName) async {
    final publicUrl =
        Supabase.instance.client.storage.from('avatars').getPublicUrl('premade/$fileName');

    await ref.read(authControllerProvider.notifier).updateAvatar(publicUrl);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            style: AppTextStyles.display.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
            ),
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: AppLoader())
          else if (_avatars.isEmpty)
            Center(
              child: Text(
                'No avatars found',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _avatars.length,
              itemBuilder: (context, index) {
                final file = _avatars[index];
                final imageUrl = Supabase.instance.client.storage
                    .from('avatars')
                    .getPublicUrl('premade/${file.name}');

                return GestureDetector(
                  onTap: () => _selectAvatar(file.name),
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
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
