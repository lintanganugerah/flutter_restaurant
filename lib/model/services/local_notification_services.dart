import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationServices {
  static final LocalNotificationServices _instance =
      LocalNotificationServices._internal();

  factory LocalNotificationServices() => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotificationServices._internal();

  Future<void> init() async {
    // Inisialisasi pengaturan untuk Android dan iOS
    const AndroidInitializationSettings
    initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    ); // ganti 'app_icon' dengan nama ikon Anda di android/app/src/main/res/mipmap

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Inisialisasi zona waktu
    tz.initializeTimeZones();

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
      final notificationEnabled = await _isAndroidPermissionGranted();
      if (!notificationEnabled) {
        final requestNotificationsPermission =
            await _requestAndroidNotificationsPermission();
        return requestNotificationsPermission;
      }
      return notificationEnabled;
    } else {
      return false;
    }
  }

  notificationDetail() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_reminder_channel_id',
        'Daily Reminder Channel',
        channelDescription: 'Channel for daily lunch reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Metode untuk menjadwalkan notifikasi harian
  Future<void> scheduleDailyLunchReminder() async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID notifikasi
      'Waktunya Makan Siang!',
      'Jangan lupa istirahat dan nikmati makan siangmu.',
      _nextInstanceOfElevenAM(),
      notificationDetail(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // Ulangi setiap hari pada waktu yang sama
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Metode untuk membatalkan notifikasi
  Future<void> cancelDailyLunchReminder() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }

  // Helper untuk mendapatkan waktu jam 11:00 berikutnya
  tz.TZDateTime _nextInstanceOfElevenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11,
    ); // Set jam 11:00
    return scheduledDate;
  }
}
