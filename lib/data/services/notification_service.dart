import 'dart:io';
import 'package:flutter/material.dart';
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

    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
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

      if (Platform.isAndroid) {
        final androidImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        await androidImpl?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );
      }

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
      icon: '@drawable/ic_notification',
      color: Color(0xFFD4AF37),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
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
    required String expenseId,
    required String vendorName,
    required String termLabel,
    required DateTime dueDate,
    int daysBefore = 3,
  }) async {
    final alertDate = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      9,
      0,
    ).subtract(Duration(days: daysBefore));
    final notificationId = 100000 + (expenseId.hashCode.abs() % 800000);

    await scheduleNotification(
      id: notificationId,
      title: 'Pengingat Pembayaran Vendor 🧾',
      body: 'Jatuh tempo pembayaran $termLabel untuk $vendorName dalam $daysBefore hari.',
      scheduledDate: alertDate,
      payload: 'expense_$expenseId',
    );
  }

  /// Membatalkan pengingat pembayaran vendor.
  Future<void> cancelVendorPaymentReminder(String expenseId) async {
    final notificationId = 100000 + (expenseId.hashCode.abs() % 800000);
    await cancelNotification(notificationId);
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

  /// Mengirim notifikasi uji coba instan untuk memastikan sistem bekerja di ponsel.
  Future<void> testInstantNotification() async {
    await requestPermissions();
    await showInstantNotification(
      id: 101,
      title: 'Nikahin Siap Menemani 💍',
      body: 'Notifikasi pengingat persiapan pernikahanmu aktif dan siap menemani hari bahagiamu.',
      payload: 'test_notification',
    );
  }

  /// Menjadwalkan pengingat hitung mundur pernikahan (H-30, H-7, H-3, H-1, dan Hari H).
  Future<void> scheduleWeddingCountdownReminders({
    required DateTime weddingDate,
    required String groomName,
    required String brideName,
  }) async {
    await init();
    final couple = groomName.isNotEmpty && brideName.isNotEmpty
        ? '$groomName & $brideName'
        : 'kamu dan pasangan';
    final milestones = [
      (
        daysBefore: 30,
        id: 900030,
        title: 'H-30 Menuju Pernikahan 🌸',
        body: 'Sebulan lagi momen istimewa $couple! Cek kembali berkas KUA dan konfirmasi vendor.'
      ),
      (
        daysBefore: 7,
        id: 900007,
        title: 'H-7 Menuju Hari Bahagia ✨',
        body: 'Tinggal 1 minggu lagi! Pastikan busana, susunan acara, dan gladi panitia sudah siap.'
      ),
      (
        daysBefore: 3,
        id: 900003,
        title: 'H-3 Menuju Pernikahan 💐',
        body: 'Tiga hari lagi! Waktunya istirahat cukup dan serahkan teknis lapangan kepada tim panitia.'
      ),
      (
        daysBefore: 1,
        id: 900001,
        title: 'Besok Hari Bahagiamu! 💍',
        body: 'Bismillah, esok adalah hari yang dinanti. Semoga seluruh rangkaian acara berjalan lancar dan penuh berkah.'
      ),
      (
        daysBefore: 0,
        id: 900000,
        title: 'Selamat Menempuh Hidup Baru! 🤍',
        body: 'Hari bahagia $couple telah tiba. Selamat merayakan cinta bersama keluarga tercinta.'
      ),
    ];

    for (final m in milestones) {
      final alertDate = DateTime(
        weddingDate.year,
        weddingDate.month,
        weddingDate.day,
        9, // Jam 9 pagi
        0,
      ).subtract(Duration(days: m.daysBefore));

      if (alertDate.isAfter(DateTime.now())) {
        await scheduleNotification(
          id: m.id,
          title: m.title,
          body: m.body,
          scheduledDate: alertDate,
          payload: 'wedding_countdown_${m.daysBefore}',
        );
      }
    }
  }

  /// Cancel the recurring daily reminder.
  Future<void> cancelDailyReminder() async {
    await cancelNotification(kDailyReminderNotificationId);
  }

  /// Cancel a specific scheduled notification.
  Future<void> cancelNotification(int id) async {
    await init();
    try {
      await _notificationsPlugin.cancel(id: id);
    } catch (e) {
      debugPrint('Error canceling notification: $e');
    }
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    await init();
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('Error canceling all notifications: $e');
    }
  }
}

/// Global provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
