import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/model/services/setting_services.dart';
import 'package:restaurant_flutter/viewModel/settings_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mock_function.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group("Settings Services Test (SharedPreferences Logic)", () {
    test('loadSettings returns default when prefs empty', () async {
      final prefs = await SharedPreferences.getInstance();
      final service = SettingsService(prefs);

      final setting = await service.loadSettings();
      expect(setting.isDarkMode, false); // default
      expect(setting.isDailyReminderActive, false);
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

    test(
      'saveDailyReminder should save value dan loadSettings return correct value',
      () async {
        final prefs = await SharedPreferences.getInstance();
        final service = SettingsService(prefs);

        await service.saveDailyReminder(true);
        final setting = await service.loadSettings();

        expect(setting.isDailyReminderActive, true);
      },
    );
  });

  group('SettingsViewModel (Provider & Notification Logic)', () {
    late SettingsViewModel viewModel;
    late MockSettingsService mockSettingsService;
    late MockLocalNotificationServices mockNotificationServices;

    setUp(() {
      // Inisialisasi ulang semua komponen sebelum setiap tes
      // untuk memastikan tes berjalan secara independen (tidak ada state bocor).
      mockSettingsService = MockSettingsService();
      mockNotificationServices = MockLocalNotificationServices();
      viewModel = SettingsViewModel(
        mockSettingsService,
        mockNotificationServices,
      );
    });

    test(
      'State awal harus SettingsStateLoaded dengan nilai default setelah inisialisasi',
      () async {
        // Jeda agar Future loadSettingsdi dalam constructor selesai.
        await Future.delayed(Duration.zero);

        // Assert
        expect(viewModel.state, isA<SettingsStateLoaded>());
        final state = viewModel.state as SettingsStateLoaded;
        expect(state.setting.isDarkMode, isFalse);
        expect(state.setting.isDailyReminderActive, isFalse);
      },
    );

    test(
      'toggleDailyReminder (ON) harus menjadwalkan notifikasi jika izin diberikan',
      () async {
        // Atur agar mock notifikasi "mengizinkan" permission
        mockNotificationServices.permissionsGrantedResult = true;
        await Future.delayed(Duration.zero); // Pastikan state awal sudah Loaded

        await viewModel.toggleDailyReminder(value: true, hour: 11, minute: 0);

        // Pastikan service notifikasi dipanggil dengan benar
        expect(mockNotificationServices.requestPermissionsCallCount, 1);
        expect(mockNotificationServices.scheduleCallCount, 1);

        final state = viewModel.state as SettingsStateLoaded;
        expect(state.setting.isDailyReminderActive, isTrue);
      },
    );

    test(
      'toggleDailyReminder (ON) TIDAK boleh menjadwalkan notifikasi jika izin ditolak',
      () async {
        // Atur agar mock notifikasi "menolak" permission
        mockNotificationServices.permissionsGrantedResult = false;
        await Future.delayed(Duration.zero);

        await viewModel.toggleDailyReminder(value: true, hour: 11, minute: 0);

        // Pastikan service notifikasi TIDAK menjadwalkan apa pun
        expect(mockNotificationServices.requestPermissionsCallCount, 1);
        expect(mockNotificationServices.scheduleCallCount, 0);

        // Pastikan state di ViewModel dikembalikan ke false
        final state = viewModel.state as SettingsStateLoaded;
        expect(state.setting.isDailyReminderActive, isFalse);
      },
    );

    test('toggleDailyReminder (OFF) harus membatalkan notifikasi', () async {
      // Jeda agar Future loadSettingsdi dalam constructor selesai.
      await Future.delayed(Duration.zero);

      await viewModel.toggleDailyReminder(value: false, hour: 11, minute: 0);

      expect(mockNotificationServices.cancelCallCount, 1);

      expect(mockNotificationServices.requestPermissionsCallCount, 0);
      expect(mockNotificationServices.scheduleCallCount, 0);

      final state = viewModel.state as SettingsStateLoaded;
      expect(state.setting.isDailyReminderActive, isFalse);
    });
  });
}
