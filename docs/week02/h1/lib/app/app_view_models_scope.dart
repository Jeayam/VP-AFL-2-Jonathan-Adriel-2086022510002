import 'package:flutter/widgets.dart';

import '../features/history/viewmodels/history_view_model.dart';
import '../features/roster/viewmodels/character_detail_view_model.dart';
import '../features/roster/viewmodels/roster_view_model.dart';
import '../features/settings/viewmodels/settings_view_model.dart';

typedef CharacterDetailViewModelFactory =
    CharacterDetailViewModel Function(String characterId);

class AppViewModelsScope extends InheritedWidget {
  final RosterViewModel rosterViewModel;
  final HistoryViewModel historyViewModel;
  final SettingsViewModel settingsViewModel;
  final CharacterDetailViewModelFactory createCharacterDetailViewModel;

  const AppViewModelsScope({
    super.key,
    required this.rosterViewModel,
    required this.historyViewModel,
    required this.settingsViewModel,
    required this.createCharacterDetailViewModel,
    required super.child,
  });

  static AppViewModelsScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppViewModelsScope>();
    if (scope == null) {
      throw FlutterError('AppViewModelsScope tidak ditemukan di widget tree.');
    }
    return scope;
  }

  @override
  bool updateShouldNotify(AppViewModelsScope oldWidget) =>
      rosterViewModel != oldWidget.rosterViewModel ||
      historyViewModel != oldWidget.historyViewModel ||
      settingsViewModel != oldWidget.settingsViewModel ||
      createCharacterDetailViewModel !=
          oldWidget.createCharacterDetailViewModel;
}
