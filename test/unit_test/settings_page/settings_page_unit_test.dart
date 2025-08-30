import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/model/services/setting_services.dart';
import 'package:restaurant_flutter/model/setting.dart';
import 'package:restaurant_flutter/viewModel/settings_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group("Settings Services Test", () {
    test('loadSettings returns default when prefs empty', () async {
      final prefs = await SharedPreferences.getInstance();
      final service = SettingsService(prefs);

      final setting = await service.loadSettings();
      expect(setting.isDarkMode, false); // default
    });

    test(
      'saveDarkMode saves value correctly, and load settings works correctly',
      () async {
        final prefs = await SharedPreferences.getInstance();
        final service = SettingsService(prefs);

        await service.saveDarkMode(true);
        final setting = await service.loadSettings();
        expect(setting.isDarkMode, true);
      },
    );
  });

  group("Setting ViewModel test", () {
    test(
      "Initial load success are returning state loaded and value correctly",
      () async {
        final prefs = await SharedPreferences.getInstance();
        final service = MockSettingsServices(prefs);
        final vm = SettingsViewModel(service);

        await Future.delayed(Duration.zero); // tunggu async di constructor

        expect(vm.state, isA<SettingsStateLoaded>());
        final loaded = vm.state as SettingsStateLoaded;
        expect(loaded.setting.isDarkMode, false);
      },
    );

    test('Initial load failure are returning state Error', () async {
      final prefs = await SharedPreferences.getInstance();
      final service = MockSettingsServiceFailure(prefs);
      final vm = SettingsViewModel(service);

      await Future.delayed(Duration.zero);

      expect(vm.state, isA<SettingsStateError>());
      final error = vm.state as SettingsStateError;

      //Expect ViewModel mengembalikan pesan error
      expect(error.message, "Gagal memuat settings.");
    });
  });
}

//Kita mock service untuk unit test view model
//Butuh mock services dikarenakan kita hanya ingin test view model
//Jika integration test maka kita tidak butuh mock services
class MockSettingsServices extends SettingsService {
  Setting _setting = Setting(isDarkMode: false);

  MockSettingsServices(super._pref);

  @override
  Future<Setting> loadSettings() async => _setting;

  @override
  Future<void> saveDarkMode(bool isDarkMode) async {
    _setting = _setting.copyWith(isDarkMode: isDarkMode);
  }
}

class MockSettingsServiceFailure extends MockSettingsServices {
  MockSettingsServiceFailure(super._pref);

  @override
  Future<Setting> loadSettings() async {
    throw Exception();
  }
}
