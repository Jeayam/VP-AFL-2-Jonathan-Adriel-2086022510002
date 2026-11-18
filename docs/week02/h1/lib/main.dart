import 'package:flutter/material.dart';

import 'app/app_router.dart';
import 'app/app_view_models_scope.dart';
import 'core/theme/app_theme.dart';
import 'features/history/data/repositories/history_repository_impl.dart';
import 'features/history/data/services/history_file_service.dart';
import 'features/history/data/services/history_service.dart';
import 'features/history/domain/repositories/history_repository.dart';
import 'features/history/viewmodels/history_view_model.dart';
import 'features/roster/data/repositories/character_repository_impl.dart';
import 'features/roster/data/services/character_asset_service.dart';
import 'features/roster/data/services/element_asset_service.dart';
import 'features/roster/data/services/role_asset_service.dart';
import 'features/roster/data/repositories/in_memory_character_repository.dart';
import 'features/roster/domain/repositories/character_repository.dart';
import 'features/roster/viewmodels/character_detail_view_model.dart';
import 'features/roster/viewmodels/roster_view_model.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/data/services/settings_service.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/viewmodels/settings_view_model.dart';

/// SOURCE SWAP: ubah HANYA baris ini untuk memindahkan sumber data karakter.
/// false = file JSON di assets/data/, true = data in-memory (tanpa file).
const _useInMemorySource = false;

CharacterRepository _createCharacterRepository({required bool inMemory}) {
  if (inMemory) return const InMemoryCharacterRepository();
  return const CharacterRepositoryImpl(
    characterService: CharacterAssetService(),
    elementService: ElementAssetService(),
    roleService: RoleAssetService(),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final CharacterRepository characterRepository = _createCharacterRepository(
    inMemory: _useInMemorySource,
  );
  runApp(
    MyApp(
      characterRepository: characterRepository,
      historyRepository: HistoryRepositoryImpl(
        historyFileService: const HistoryFileService(),
        historyService: const HistoryService(),
        characterRepository: characterRepository,
      ),
      settingsRepository: SettingsRepositoryImpl(SettingsService()),
    ),
  );
}

class MyApp extends StatefulWidget {
  final CharacterRepository characterRepository;
  final HistoryRepository historyRepository;
  final SettingsRepository settingsRepository;
  final String initialRoute;

  const MyApp({
    super.key,
    required this.characterRepository,
    required this.historyRepository,
    required this.settingsRepository,
    this.initialRoute = AppRoutes.home,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _rosterViewModel = RosterViewModel(widget.characterRepository);
  late final _historyViewModel = HistoryViewModel(widget.historyRepository);
  late final _settingsViewModel = SettingsViewModel(widget.settingsRepository);

  CharacterDetailViewModel _createCharacterDetailViewModel(String characterId) {
    return CharacterDetailViewModel(
      characterId: characterId,
      characterRepository: widget.characterRepository,
      historyRepository: widget.historyRepository,
    );
  }

  @override
  void initState() {
    super.initState();
    _rosterViewModel.load();
    _settingsViewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settingsViewModel,
      builder: (context, _) {
        return AppViewModelsScope(
          rosterViewModel: _rosterViewModel,
          historyViewModel: _historyViewModel,
          settingsViewModel: _settingsViewModel,
          createCharacterDetailViewModel: _createCharacterDetailViewModel,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Hero Codex • Character Archives',
            initialRoute: widget.initialRoute,
            onGenerateInitialRoutes: generateInitialAppRoutes,
            onGenerateRoute: generateAppRoute,
            themeMode: _settingsViewModel.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _rosterViewModel.dispose();
    _historyViewModel.dispose();
    _settingsViewModel.dispose();
    super.dispose();
  }
}
