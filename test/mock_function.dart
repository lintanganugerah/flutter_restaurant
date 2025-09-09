import 'package:restaurant_flutter/model/services/local_notification_services.dart';
import 'package:restaurant_flutter/model/services/setting_services.dart';
import 'package:restaurant_flutter/model/setting.dart';

/// Mock untuk SettingsService yang berinteraksi dengan SharedPreferences ke sebuah objek di memori
class MockSettingsService implements SettingsService {
  Setting _setting = Setting(isDarkMode: false, isDailyReminderActive: false);

  @override
  Future<Setting> loadSettings() async {
    // Mensimulasikan pengambilan data dari "penyimpanan".
    return _setting;
  }

  @override
  Future<void> saveDarkMode(bool isDarkMode) async {
    // Mensimulasikan penyimpanan data.
    _setting = _setting.copyWith(isDarkMode: isDarkMode);
  }

  @override
  Future<void> saveDailyReminder(bool isActive) async {
    // Mensimulasikan penyimpanan data.
    _setting = _setting.copyWith(isDailyReminderActive: isActive);
  }

  // Karena kita implementasi, kita butuh getter _pref palsu ini.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

/// Mock LocalNotificationServices.
/// Memungkinkan kita mengontrol dan melacak interaksi notifikasi.
class MockLocalNotificationServices implements LocalNotificationServices {
  // Properti untuk melacak panggilan metode
  int scheduleCallCount = 0;
  int cancelCallCount = 0;
  int requestPermissionsCallCount = 0;

  // Properti untuk mengontrol hasil dari `requestPermissions` selama tes
  bool? permissionsGrantedResult;

  @override
  Future<void> cancelDailyLunchReminder() async {
    cancelCallCount++;
  }

  @override
  Future<bool?> requestPermissions() async {
    requestPermissionsCallCount++;
    return permissionsGrantedResult;
  }

  @override
  Future<void> scheduleDailyLunchReminder({
    required dynamic hour,
    required int minute,
  }) async {
    scheduleCallCount++;
  }

  // Karena kita implementasi, kita butuh getter _pref palsu ini.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
