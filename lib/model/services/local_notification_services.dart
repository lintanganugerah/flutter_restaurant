import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class LocalNotificationServices {
  static final LocalNotificationServices _instance =
      LocalNotificationServices._internal();

  factory LocalNotificationServices() => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotificationServices._internal();

  Future<void> init() async {
    //init zona waktu
    tz.initializeTimeZones();
    final String currentTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTz));
    debugPrint(currentTz);
    debugPrint("${tz.local}");

    // Inisialisasi pengaturan untuk Android dan iOS
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> _isAndroidPermissionGranted() async {
    return await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<bool> _requestAndroidNotificationsPermission() async {
    return await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission() ??
        false;
  }

  Future<bool> _requestExactAlarmsPermission() async {
    return await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestExactAlarmsPermission() ??
        false;
  }

  Future<bool?> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final requestNotificationsPermission = await androidImplementation
          ?.requestNotificationsPermission();
      final notificationEnabled = await _isAndroidPermissionGranted();
      final requestAlarmEnabled = await _requestExactAlarmsPermission();
      return (requestNotificationsPermission ?? false) &&
          notificationEnabled &&
          requestAlarmEnabled;
    } else {
      return false;
    }
  }

  notificationDetail() {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'daily_reminder_channel_id',
      'Daily Reminder Channel',
      channelDescription: 'Channel for daily lunch reminders',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    return NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }

  // Metode untuk menjadwalkan notifikasi harian
  Future<void> scheduleDailyLunchReminder({
    required hour,
    required int minute,
  }) async {
    //Ambil data waktu dan tentukan jadwal
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
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

    debugPrint('⏰ Scheduling notification for: $scheduledDate');

    //Jadwalkan notifikasi nya
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      10, // ID notifikasi
      'Waktunya Makan Siang!',
      'Jangan lupa istirahat dan makan siang. Yuk cari restoran disini.',
      scheduledDate,
      notificationDetail(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint('Notification Successfully scheduled');
  }

  // Metode untuk membatalkan notifikasi
  Future<void> cancelDailyLunchReminder() async {
    await _flutterLocalNotificationsPlugin.cancel(10);
    debugPrint('Notification Daily Reminder Successfully Canceled');
  }

  /// Mengembalikan daftar semua notifikasi yang sedang dijadwalkan.
  Future<List<PendingNotificationRequest>>
  getPendingNotificationRequests() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// Membatalkan SEMUA notifikasi yang dijadwalkan.
  /// Berguna untuk membersihkan state sebelum memulai tes.
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showNotification() async {
    return _flutterLocalNotificationsPlugin.show(
      99,
      "test",
      "Isi body test",
      notificationDetail(),
    );
  }

  tz.TZDateTime _nextInstanceOfElevenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
