abstract interface class SettingsRepository {
  Future<bool> loadDarkMode();

  Future<void> saveDarkMode(bool enabled);
}
