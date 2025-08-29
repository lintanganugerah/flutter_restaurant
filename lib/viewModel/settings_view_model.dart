import 'package:flutter/widgets.dart';
import 'package:restaurant_flutter/model/services/setting_services.dart';
import 'package:restaurant_flutter/model/setting.dart';

class SettingsViewModel extends ChangeNotifier {
  //Service yang digunakan untuk berkomunikasi dengan sharedPreferences
  final SettingsService _service;

  // Hanya satu variabel state, dimulai dengan loading
  SettingsState _state = SettingsStateLoading();

  SettingsState get state => _state;

  //Langsung jalankan load settings saat view model dibuat
  SettingsViewModel(this._service) {
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
