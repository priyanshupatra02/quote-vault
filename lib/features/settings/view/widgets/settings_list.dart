import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/core/theme/theme_controller.dart';

class SettingsList extends ConsumerWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(
            'Settings',
            style: AppTextStyles.display(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              SettingsListItem(
                title: 'Notifications',
                icon: Icons.notifications,
                iconColor: Colors.redAccent,
                bgIconColor: Colors.redAccent.withOpacity(0.1),
              ),
              _Divider(),
              SettingsListItem(
                title: 'Appearance',
                icon: Icons.dark_mode,
                iconColor: Colors.blueAccent,
                bgIconColor: Colors.blueAccent.withOpacity(0.1),
                trailing: Row(
                  children: [
                    Text(
                      Theme.of(context).brightness == Brightness.dark ? 'Dark' : 'Light',
                      style: AppTextStyles.display(context).copyWith(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: Theme.of(context).brightness == Brightness.dark,
                      onChanged: (value) {
                        ref.read(themecontrollerProvider.notifier).changeTheme(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                      },
                      activeThumbColor: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
              _Divider(),
              SettingsListItem(
                title: 'Privacy & Data',
                icon: Icons.lock,
                iconColor: Colors.greenAccent,
                bgIconColor: Colors.greenAccent.withOpacity(0.1),
              ),
              _Divider(),
              SettingsListItem(
                title: 'Account',
                icon: Icons.person,
                iconColor: Colors.grey,
                bgIconColor: Colors.grey.withOpacity(0.1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgIconColor;
  final Widget? trailing;

  const SettingsListItem({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.bgIconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // For ink ripple if needed
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bgIconColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.display(context).copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text(context),
                  ),
                ),
              ),
              trailing ??
                  Icon(Icons.chevron_right, color: AppColors.textSecondary(context), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.05),
      indent: 16,
      endIndent: 16,
    );
  }
}
