import '../../domain/repositories/settings_repository.dart';
import '../services/settings_service.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsService settingsService;

  const SettingsRepositoryImpl(this.settingsService);

  @override
  Future<bool> loadDarkMode() => settingsService.loadDarkMode();

  @override
  Future<void> saveDarkMode(bool enabled) =>
      settingsService.saveDarkMode(enabled);
}
