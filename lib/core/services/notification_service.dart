import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Notification service for daily quote notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    debugPrint('NotificationService initialized');
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Navigate to quote detail or home page based on payload
  }

  /// Request notification permissions (especially for iOS 10+)
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    } else if (Platform.isAndroid) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return result ?? false;
    }
    return false;
  }

  /// Schedule daily quote notification at a specific time
  Future<void> scheduleDailyQuoteNotification({
    required int hour,
    required int minute,
    required String quoteContent,
    required String author,
  }) async {
    await _notifications.zonedSchedule(
      0, // Notification ID for daily quote
      '✨ Daily Quote',
      '"$quoteContent" — $author',
      _nextInstanceOfTime(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_quote_channel',
          'Daily Quote',
          channelDescription: 'Daily inspirational quote notifications',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            '"$quoteContent" — $author',
            contentTitle: '✨ Daily Quote',
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Repeats daily
      payload: 'daily_quote',
    );

    debugPrint('Daily quote notification scheduled for $hour:$minute');
  }

  /// Calculate next instance of the specified time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Show immediate notification (for testing)
  Future<void> showTestNotification({
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel',
        'Test Notifications',
        channelDescription: 'For testing notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  /// Cancel daily quote notification
  Future<void> cancelDailyQuoteNotification() async {
    await _notifications.cancel(0);
    debugPrint('Daily quote notification cancelled');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('All notifications cancelled');
  }
}

/// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
