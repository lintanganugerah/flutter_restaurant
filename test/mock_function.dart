import 'package:restaurant_flutter/model/services/local_notification_services.dart';
import 'package:restaurant_flutter/model/services/restaurant_services.dart';
import 'package:restaurant_flutter/model/services/setting_services.dart';
import 'package:restaurant_flutter/model/setting.dart';
import 'package:restaurant_flutter/model/restaurant.dart';

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

/// Mock Restaurant Services untuk mengontrol outputnya untuk setiap skenario tes.
class MockRestaurantServices implements RestaurantServices {
  // Properti untuk menyimpan data palsu yang akan dikembalikan
  RestaurantListResponse? listResponseToReturn;
  RestaurantDetailResponse? detailResponseToReturn;
  RestaurantSearchResponse? searchResponseToReturn;

  // Properti untuk menyimulasikan error
  Exception? exceptionToThrow;

  // Properti untuk melacak panggilan method
  int getListRestaurantsCallCount = 0;
  int getDetailRestaurantCallCount = 0;
  int searchRestaurantsCallCount = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {}

  @override
  Future<RestaurantListResponse> getListRestaurants() async {
    getListRestaurantsCallCount++;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return listResponseToReturn!;
  }

  @override
  Future<RestaurantDetailResponse> getDetailRestaurant(String id) async {
    getDetailRestaurantCallCount++;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return detailResponseToReturn!;
  }

  @override
  Future<RestaurantSearchResponse> searchRestaurants(String query) async {
    searchRestaurantsCallCount++;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return searchResponseToReturn!;
  }
}
