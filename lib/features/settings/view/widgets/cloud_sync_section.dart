import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloudSyncSection extends StatefulWidget {
  const CloudSyncSection({super.key});

  @override
  State<CloudSyncSection> createState() => _CloudSyncSectionState();
}

class _CloudSyncSectionState extends State<CloudSyncSection> {
  bool _isSynced = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSyncPreference();
  }

  Future<void> _loadSyncPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSynced = prefs.getBool('cloud_sync_enabled') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _updateSyncPreference(bool value) async {
    setState(() => _isSynced = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cloud_sync_enabled', value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.cloud_sync,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cloud Sync',
                          style: AppTextStyles.display.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isSynced
                          ? 'Your quotes are backed up across all devices automatically.'
                          : 'Cloud sync is paused. New quotes will only be saved locally.',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 14,
                        color: AppColors.textSecondary(context),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_isSynced)
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF059669), // Emerald 600
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Last synced: Just now',
                            style: AppTextStyles.label.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Switch(
                value: _isSynced,
                onChanged: _updateSyncPreference,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF22C55E), // Green 500
              ),
            ],
          ),
        ],
      ),
    );
  }
}
