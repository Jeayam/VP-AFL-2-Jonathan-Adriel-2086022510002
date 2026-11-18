import 'package:flutter/foundation.dart';

import '../domain/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository repository;
  SettingsState _state = const SettingsLoading();
  bool _disposed = false;

  SettingsViewModel(this.repository);

  SettingsState get state => _state;

  bool get isDarkMode => switch (_state) {
    SettingsLoaded(:final isDarkMode) => isDarkMode,
    SettingsFailure(:final isDarkMode) => isDarkMode,
    SettingsLoading() => true,
  };

  Future<void> load() async {
    _publish(const SettingsLoading());
    try {
      final enabled = await repository.loadDarkMode();
      if (_disposed) return;
      _publish(SettingsLoaded(isDarkMode: enabled));
    } on Exception {
      if (_disposed) return;
      _publish(
        const SettingsFailure(
          'Pengaturan tema gagal dimuat. Tema gelap digunakan sementara.',
        ),
      );
    }
  }

  Future<void> toggleTheme() => setDarkMode(!isDarkMode);

  Future<void> setDarkMode(bool enabled) async {
    final previous = isDarkMode;
    final updated = SettingsLoaded(isDarkMode: enabled);
    _publish(updated);
    try {
      await repository.saveDarkMode(updated.isDarkMode);
      if (_disposed) return;
    } on Exception {
      if (_disposed) return;
      _publish(
        SettingsFailure(
          'Perubahan tema gagal disimpan. Coba lagi.',
          isDarkMode: previous,
        ),
      );
    }
  }

  void _publish(SettingsState state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
