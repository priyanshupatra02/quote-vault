import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/core/theme/theme_color_controller.dart';
import 'package:quote_vault/core/theme/theme_controller.dart';

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentColor = ref.watch(themeColorControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12),
          child: Text(
            'APPEARANCE',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary(context),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            children: [
              // Dark Mode Toggle
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.dark_mode_outlined,
                        size: 20,
                        color: isDark ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Dark Mode',
                      style: AppTextStyles.display.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text(context),
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: isDark,
                      onChanged: (val) {
                        ref
                            .read(themecontrollerProvider.notifier)
                            .changeTheme(val ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeThumbColor: Colors.white,
                      activeTrackColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey[200]),

              // Accent Color Picker
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accent Color',
                      style: AppTextStyles.display.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _ColorOption(
                          color: const Color(0xFF5417cf), // Brand Purple
                          isSelected: currentColor.value == const Color(0xFF5417cf).value,
                          onTap: () => ref
                              .read(themeColorControllerProvider.notifier)
                              .changeColor(const Color(0xFF5417cf)),
                        ),
                        const SizedBox(width: 16),
                        _ColorOption(
                          color: const Color(0xFFFFD700), // Gold
                          isSelected: currentColor.value == const Color(0xFFFFD700).value,
                          onTap: () => ref
                              .read(themeColorControllerProvider.notifier)
                              .changeColor(const Color(0xFFFFD700)),
                        ),
                        const SizedBox(width: 16),
                        _ColorOption(
                          color: const Color(0xFF000080), // Navy
                          isSelected: currentColor.value == const Color(0xFF000080).value,
                          onTap: () => ref
                              .read(themeColorControllerProvider.notifier)
                              .changeColor(const Color(0xFF000080)),
                        ),
                        const SizedBox(width: 16),
                        _ColorOption(
                          color: const Color(0xFF50C878), // Emerald
                          isSelected: currentColor.value == const Color(0xFF50C878).value,
                          onTap: () => ref
                              .read(themeColorControllerProvider.notifier)
                              .changeColor(const Color(0xFF50C878)),
                        ),
                        const SizedBox(width: 16),
                        _ColorOption(
                          color: const Color(0xFFFF3B30), // Red
                          isSelected: currentColor.value == const Color(0xFFFF3B30).value,
                          onTap: () => ref
                              .read(themeColorControllerProvider.notifier)
                              .changeColor(const Color(0xFFFF3B30)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Selection ring
          if (isSelected)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
            ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
          ),
        ],
      ),
    );
  }
}
