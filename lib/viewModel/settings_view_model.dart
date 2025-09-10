import 'package:flutter/widgets.dart';
import 'package:restaurant_flutter/model/services/local_notification_services.dart';
import 'package:restaurant_flutter/model/services/setting_services.dart';
import 'package:restaurant_flutter/model/setting.dart';

class SettingsViewModel extends ChangeNotifier {
  //Service yang digunakan untuk berkomunikasi dengan sharedPreferences
  SettingsService _service;
  final LocalNotificationServices _notificationServices;

  // Hanya satu variabel state, dimulai dengan loading
  SettingsState _state = SettingsStateLoading();

  SettingsState get state => _state;

  //Langsung jalankan load settings saat view model dibuat
  SettingsViewModel(this._service, this._notificationServices) {
    loadSettings();
  }

  void _emit(SettingsState state) {
    _state = state;
    notifyListeners();
  }

  //Load Semua Setting
  Future<void> loadSettings() async {
    try {
      _emit(SettingsStateLoading());

      final loadedSettings = await _service.loadSettings();
      _emit(SettingsStateLoaded(loadedSettings));
    } catch (e) {
      _emit(SettingsStateError("Gagal memuat settings."));
    }
  }

  // Settings Switch dark mode
  Future<void> toggleDarkMode(bool value) async {
    try {
      if (_state is SettingsStateLoaded) {
        //Mark state sekarang sebagai loaded (agar bisa akses setting)
        final currentState = _state as SettingsStateLoaded;
        final currentSetting = currentState.setting;

        // Update state
        final newSetting = currentSetting.copyWith(isDarkMode: value);
        _emit(SettingsStateLoaded(newSetting));

        // Simpan ke service
        await _service.saveDarkMode(value);
      }
    } catch (e) {
      _emit(SettingsStateError(e.toString()));
    }
  }

  Future<void> toggleDailyReminder({
    required bool value,
    required int hour,
    required int minute,
  }) async {
    try {
      if (_state is SettingsStateLoaded) {
        final currentState = _state as SettingsStateLoaded;
        final currentSetting = currentState.setting;

        // Update UI state secara optimis agar responsif
        final newSetting = currentSetting.copyWith(
          isDailyReminderActive: value,
        );
        _emit(SettingsStateLoaded(newSetting));

        // Simpan state ke SharedPreferences
        await _service.saveDailyReminder(value);

        debugPrint('Value Swtich baru : $value');

        // Cek apakah value true atau tidak. Jika false (switch off) maka cancel notifikasi
        if (value) {
          // Minta izin lalu jadwalkan notifikasi
          final permissionsGranted = await _notificationServices
              .requestPermissions();
          debugPrint('Permission granted : $permissionsGranted');
          //Cek apakah Permission Granted untuk menampilkan notifikasi
          if (permissionsGranted!) {
            debugPrint('Scheduling Daily Reminder');
            await _notificationServices.scheduleDailyLunchReminder(
              hour: hour,
              minute: minute,
            );
          } else {
            debugPrint('Izin Ditolak');
            // Jika izin ditolak, kembalikan switch ke posisi off (false)
            final finalSetting = newSetting.copyWith(
              isDailyReminderActive: false,
            );
            _emit(SettingsStateLoaded(finalSetting));
            await _service.saveDailyReminder(false);
          }
        } else {
          debugPrint('Cancel Daily Lunch Reminder');
          // Batalkan notifikasi
          await _notificationServices.cancelDailyLunchReminder();
        }
      }
    } catch (e) {
      _emit(SettingsStateError(e.toString()));
    }
  }

  // Digunakan untuk memperbarui instance previousViewModel yang sudah ada bukan membuat yang baru pada ProxyProvider.
  // Sehingga dapat mempertahankan viewModel lama yang sudah dibuat dari provider
  void updateServices(SettingsService newService) {
    _service = newService;
  }
}

// Sealed class utama
sealed class SettingsState {}

// Loading
class SettingsStateLoading extends SettingsState {}

// Berhasil
class SettingsStateLoaded extends SettingsState {
  final Setting setting;

  SettingsStateLoaded(this.setting);
}

// Error
class SettingsStateError extends SettingsState {
  final String message;

  SettingsStateError(this.message);
}
