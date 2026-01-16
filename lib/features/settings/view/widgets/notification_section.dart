import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/services/notification_service.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/data/network/supabase_helper_pod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for storing the scheduled notification time
final dailyNotificationTimeProvider = StateProvider<TimeOfDay?>((ref) => null);

/// Provider for notification enabled state
final dailyNotificationEnabledProvider = StateProvider<bool>((ref) => false);

/// Provider for loading state
final notificationLoadingProvider = StateProvider<bool>((ref) => false);

class NotificationSection extends ConsumerStatefulWidget {
  const NotificationSection({super.key});

  @override
  ConsumerState<NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends ConsumerState<NotificationSection> {
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreferences();
    });
  }

  Future<void> _loadPreferences() async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    ref.read(notificationLoadingProvider.notifier).state = true;

    try {
      final supabaseHelper = ref.read(supabaseHelperProvider);
      final result = await supabaseHelper.getProfile(userId: userId);

      await result.when(
        (profile) async {
          debugPrint(
              'Loaded profile preferences: enabled=${profile.notificationEnabled}, time=${profile.notificationHour}:${profile.notificationMinute}');

          if (mounted) {
            // 1. Update UI State
            ref.read(dailyNotificationEnabledProvider.notifier).state = profile.notificationEnabled;
            ref.read(dailyNotificationTimeProvider.notifier).state = TimeOfDay(
              hour: profile.notificationHour,
              minute: profile.notificationMinute,
            );

            // 2. Reschedule if enabled (Ensures schedules exist and are fresh)
            if (profile.notificationEnabled) {
              try {
                debugPrint('Resyncing schedules from backend preferences...');
                final notificationService = ref.read(notificationServiceProvider);
                await notificationService.initialize();

                // Fetch fresh quotes
                final quotesResult = await supabaseHelper.getRandomQuotes(count: 7);

                await quotesResult.when(
                  (quotes) async {
                    final quoteList = quotes
                        .map((q) => {
                              'content': q.content,
                              'author': q.author,
                            })
                        .toList();

                    await notificationService.scheduleMultipleQuotes(
                      hour: profile.notificationHour,
                      minute: profile.notificationMinute,
                      quotes: quoteList,
                    );
                    debugPrint(
                        'Successfully rescheduled notifications for ${profile.notificationHour}:${profile.notificationMinute}');
                  },
                  (error) async {
                    debugPrint('Failed to fetch quotes for reschedule: ${error.errorMessage}');
                    // Fallback default
                    await notificationService.scheduleDailyQuoteNotification(
                      hour: profile.notificationHour,
                      minute: profile.notificationMinute,
                      quoteContent: 'Start your day with inspiration!',
                      author: 'QuoteVault',
                    );
                  },
                );
              } catch (e) {
                // Log but don't crash UI for background sync error
                debugPrint('Error rescheduling on load: $e');
              }
            }
          }
        },
        (error) {
          debugPrint('Error loading profile: ${error.errorMessage}');
          if (mounted) {
            ref.read(dailyNotificationTimeProvider.notifier).state =
                const TimeOfDay(hour: 9, minute: 0);
          }
        },
      );
    } finally {
      if (mounted) {
        ref.read(notificationLoadingProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notificationTime = ref.watch(dailyNotificationTimeProvider);
    final isEnabled = ref.watch(dailyNotificationEnabledProvider);
    final isLoading = ref.watch(notificationLoadingProvider);

    String timeDisplay = notificationTime != null ? _formatTime(notificationTime) : '09:00 AM';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12),
          child: Text(
            'NOTIFICATIONS',
            style: AppTextStyles.label(context).copyWith(
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
              // Enable/Disable Toggle Row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isEnabled
                            ? AppColors.primary.withOpacity(0.1)
                            : (isDark ? Colors.grey[800] : Colors.grey[100]),
                        shape: BoxShape.circle,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              Icons.notifications_active,
                              size: 18,
                              color: isEnabled
                                  ? AppColors.primary
                                  : (isDark ? Colors.grey[300] : Colors.grey[600]),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Inspiration',
                            style: AppTextStyles.display(context).copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text(context),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isEnabled ? 'Synced to cloud ✓' : 'Disabled',
                            style: AppTextStyles.label(context).copyWith(
                              fontSize: 12,
                              color:
                                  isEnabled ? AppColors.primary : AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: isEnabled,
                      activeColor: AppColors.primary,
                      onChanged:
                          isLoading ? null : (value) => _onToggleChanged(value, notificationTime),
                    ),
                  ],
                ),
              ),

              // Time Picker Row
              if (isEnabled)
                InkWell(
                  onTap: isLoading ? null : () => _showTimePicker(context, notificationTime),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
                            Icons.schedule,
                            size: 18,
                            color: isDark ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Notification Time',
                          style: AppTextStyles.display(context).copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            timeDisplay,
                            style: AppTextStyles.display(context).copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: AppColors.textSecondary(context),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  Future<void> _onToggleChanged(bool enabled, TimeOfDay? currentTime) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    ref.read(notificationLoadingProvider.notifier).state = true;

    try {
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.initialize();

      final time = currentTime ?? const TimeOfDay(hour: 9, minute: 0);
      final supabaseHelper = ref.read(supabaseHelperProvider);

      if (enabled) {
        // Request permissions first
        final hasPermission = await notificationService.requestPermissions();
        if (!hasPermission) {
          ref.read(notificationLoadingProvider.notifier).state = false;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notification permission denied'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        // 1. SAVE TO BACKEND FIRST
        final updateResult = await supabaseHelper.updateNotificationPreferences(
          userId: userId,
          enabled: true,
          hour: time.hour,
          minute: time.minute,
        );

        // Handle Save Error
        bool saveFailed = false;
        String errorMessage = '';

        updateResult.when((success) => debugPrint('Successfully saved notification preferences'),
            (error) {
          saveFailed = true;
          errorMessage = error.errorMessage;
          debugPrint('Failed to save preferences: $errorMessage');
        });

        if (saveFailed) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Failed to save settings: $errorMessage. Please check database schema.'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Revert toggle
            ref.read(dailyNotificationEnabledProvider.notifier).state = false;
          }
          return;
        }

        // 2. Fetch random quotes
        final quotesResult = await supabaseHelper.getRandomQuotes(count: 7);

        await quotesResult.when(
          (quotes) async {
            // Schedule notifications with real quotes
            final quoteList = quotes
                .map((q) => {
                      'content': q.content,
                      'author': q.author,
                    })
                .toList();

            await notificationService.scheduleMultipleQuotes(
              hour: time.hour,
              minute: time.minute,
              quotes: quoteList,
            );
          },
          (error) async {
            // Fallback to default message if quotes fetch fails
            debugPrint('Failed to fetch quotes: ${error.errorMessage}');
            await notificationService.scheduleDailyQuoteNotification(
              hour: time.hour,
              minute: time.minute,
              quoteContent: 'Start your day with inspiration!',
              author: 'QuoteVault',
            );
          },
        );

        if (mounted) {
          ref.read(dailyNotificationEnabledProvider.notifier).state = true;
          ref.read(dailyNotificationTimeProvider.notifier).state = time;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Daily notifications enabled for ${_formatTime(time)} 🔔'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // Disable notifications locally
        await notificationService.cancelAllNotifications();

        // Disable on backend
        final updateResult = await supabaseHelper.updateNotificationPreferences(
          userId: userId,
          enabled: false,
          hour: time.hour,
          minute: time.minute,
        );

        updateResult.when(
          (success) {},
          (error) {
            debugPrint('Error syncing disable state: ${error.errorMessage}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to sync to cloud: ${error.errorMessage}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );

        if (mounted) {
          ref.read(dailyNotificationEnabledProvider.notifier).state = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Daily notifications disabled'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        ref.read(notificationLoadingProvider.notifier).state = false;
      }
    }
  }

  Future<void> _showTimePicker(BuildContext context, TimeOfDay? currentTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface(context),
              onSurface: AppColors.text(context),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      ref.read(notificationLoadingProvider.notifier).state = true;

      try {
        final supabaseHelper = ref.read(supabaseHelperProvider);

        // 1. SAVE TO BACKEND FIRST
        final updateResult = await supabaseHelper.updateNotificationPreferences(
          userId: userId,
          enabled: true,
          hour: picked.hour,
          minute: picked.minute,
        );

        // Check for error logic
        bool saveFailed = false;
        String errorMessage = '';

        updateResult.when((success) {}, (error) {
          saveFailed = true;
          errorMessage = error.errorMessage;
        });

        if (saveFailed) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update time: $errorMessage'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        // 2. Fetch quotes and reschedule
        final quotesResult = await supabaseHelper.getRandomQuotes(count: 7);

        final notificationService = ref.read(notificationServiceProvider);
        await notificationService.initialize();

        await quotesResult.when(
          (quotes) async {
            final quoteList = quotes
                .map((q) => {
                      'content': q.content,
                      'author': q.author,
                    })
                .toList();

            await notificationService.scheduleMultipleQuotes(
              hour: picked.hour,
              minute: picked.minute,
              quotes: quoteList,
            );
          },
          (error) async {
            debugPrint('Failed to fetch quotes: ${error.errorMessage}');
            await notificationService.scheduleDailyQuoteNotification(
              hour: picked.hour,
              minute: picked.minute,
              quoteContent: 'Start your day with inspiration!',
              author: 'QuoteVault',
            );
          },
        );

        ref.read(dailyNotificationTimeProvider.notifier).state = picked;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notification time updated to ${_formatTime(picked)} 🔔'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          ref.read(notificationLoadingProvider.notifier).state = false;
        }
      }
    }
  }
}
