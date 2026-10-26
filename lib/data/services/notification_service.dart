import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Local notifications service for Nikahin App.
/// Handles vendor payment deadlines, task checklists, and wedding D-Day countdown alerts.
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  bool _isInitialized = false;

  NotificationService({FlutterLocalNotificationsPlugin? notificationsPlugin})
      : _notificationsPlugin = notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'nikahin_reminders';
  static const String _channelName = 'Pengingat Nikahin';
  static const String _channelDescription =
      'Notifikasi pengingat pembayaran vendor, persiapan dokumen, dan hitung mundur pernikahan.';

  /// Initialize notification plugin with platform settings.
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
    } catch (e) {
      debugPrint('Error initializing timezones: $e');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const linuxSettings = LinuxInitializationSettings(defaultActionName: 'Open');

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      linux: linuxSettings,
    );

    try {
      await _notificationsPlugin.initialize(settings: initSettings);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  /// Request permissions on Android 13+ and iOS.
  Future<bool> requestPermissions() async {
    await init();
    try {
      if (Platform.isAndroid) {
        final androidImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        return await androidImpl?.requestNotificationsPermission() ?? false;
      } else if (Platform.isIOS) {
        final iosImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        return await iosImpl?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      } else if (Platform.isMacOS) {
        final macImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>();
        return await macImpl?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
    } catch (_) {}
    return true;
  }

  NotificationDetails _buildNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
  }

  /// Display an instant notification.
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await init();
    try {
      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _buildNotificationDetails(),
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  /// Schedule a notification for a future date/time.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    await init();
    if (scheduledDate.isBefore(DateTime.now())) return;

    try {
      final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzDate,
        notificationDetails: _buildNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  /// Helper to schedule a vendor payment due-date reminder (e.g. H-3 before due date).
  Future<void> scheduleVendorPaymentReminder({
    required int expenseId,
    required String vendorName,
    required String termLabel,
    required DateTime dueDate,
    int daysBefore = 3,
  }) async {
    final alertDate = dueDate.subtract(Duration(days: daysBefore));
    final notificationId = 100000 + expenseId;

    await scheduleNotification(
      id: notificationId,
      title: 'Pengingat Pembayaran Vendor',
      body: 'Jatuh tempo pembayaran $termLabel untuk $vendorName dalam $daysBefore hari.',
      scheduledDate: alertDate,
      payload: 'expense_$expenseId',
    );
  }

  static const int kDailyReminderNotificationId = 999999;

  /// Helper to schedule a recurring daily reminder at a specific hour and minute.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String title = 'Pengingat Persiapan Nikahin 💍',
    String body = 'Yuk cek checklist tugas, berkas KUA, dan progres vendor pernikahanmu hari ini!',
  }) async {
    await init();
    try {
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

      await _notificationsPlugin.zonedSchedule(
        id: kDailyReminderNotificationId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _buildNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'daily_reminder',
      );
    } catch (e) {
      debugPrint('Error scheduling daily reminder: $e');
    }
  }

  /// Cancel the recurring daily reminder.
  Future<void> cancelDailyReminder() async {
    await cancelNotification(kDailyReminderNotificationId);
  }

  /// Cancel a specific scheduled notification.
  Future<void> cancelNotification(int id) async {
    await init();
    await _notificationsPlugin.cancel(id: id);
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    await init();
    await _notificationsPlugin.cancelAll();
  }
}

/// Global provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
