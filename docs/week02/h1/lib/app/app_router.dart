import 'package:flutter/material.dart';

import '../features/history/view/history_screen.dart';
import '../features/roster/view/character_detail_screen.dart';
import '../features/roster/view/roster_screen.dart';
import '../features/settings/view/settings_screen.dart';
import 'app_view_models_scope.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const history = '/history';
  static const settings = '/settings';

  static String characterDetail(String characterId) =>
      '/characters/${Uri.encodeComponent(characterId)}';
}

class CharacterDetailArguments {
  final String characterId;

  const CharacterDetailArguments({required this.characterId});
}

abstract final class AppNavigation {
  static Future<void> openHistory(BuildContext context) =>
      Navigator.of(context).pushNamed(AppRoutes.history);

  static Future<void> openSettings(BuildContext context) =>
      Navigator.of(context).pushNamed(AppRoutes.settings);

  static Future<void> openCharacterDetail(
    BuildContext context, {
    required CharacterDetailArguments arguments,
  }) => Navigator.of(context).pushNamed(
    AppRoutes.characterDetail(arguments.characterId),
    arguments: arguments,
  );

  static void backOrHome(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.home);
    }
  }
}

Route<dynamic> generateAppRoute(RouteSettings settings) {
  final routeName = settings.name ?? AppRoutes.home;
  final uri = Uri.tryParse(routeName);
  final path = uri?.path ?? routeName;
  final routeArguments = settings.arguments;
  final page = switch (path) {
    AppRoutes.home => (BuildContext context) {
      final scope = AppViewModelsScope.of(context);
      return ListenableBuilder(
        listenable: scope.settingsViewModel,
        builder: (context, _) => RosterScreen(
          rosterViewModel: scope.rosterViewModel,
          isDarkMode: scope.settingsViewModel.isDarkMode,
          onDarkModeChanged: scope.settingsViewModel.setDarkMode,
        ),
      );
    },
    AppRoutes.history => (BuildContext context) {
      final scope = AppViewModelsScope.of(context);
      return HistoryScreen(
        viewModel: scope.historyViewModel,
        onBack: () => AppNavigation.backOrHome(context),
        onCharacterSelected: (character) async {
          await AppNavigation.openCharacterDetail(
            context,
            arguments: CharacterDetailArguments(characterId: character.id),
          );
          await scope.historyViewModel.load();
        },
      );
    },
    AppRoutes.settings => (BuildContext context) {
      final scope = AppViewModelsScope.of(context);
      return SettingsScreen(
        settingsViewModel: scope.settingsViewModel,
        onClearHistory: scope.historyViewModel.clearHistory,
        onBack: () => AppNavigation.backOrHome(context),
      );
    },
    _ => _detailPage(path, routeArguments),
  };

  return MaterialPageRoute<void>(settings: settings, builder: page);
}

WidgetBuilder _detailPage(String path, Object? arguments) {
  final pathSegments = Uri.tryParse(path)?.pathSegments ?? const <String>[];
  final pathCharacterId =
      pathSegments.length == 2 && pathSegments.first == 'characters'
      ? pathSegments[1]
      : null;
  final characterId = switch (arguments) {
    CharacterDetailArguments(:final characterId) => characterId,
    null => pathCharacterId,
    _ => null,
  };

  if (characterId == null || characterId.isEmpty) {
    return (_) => const _UnknownRouteScreen();
  }

  return (context) {
    final scope = AppViewModelsScope.of(context);
    return CharacterDetailScreen(
      characterId: characterId,
      createViewModel: scope.createCharacterDetailViewModel,
      onBack: () => AppNavigation.backOrHome(context),
    );
  };
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
    body: Center(
      child: FilledButton(
        onPressed: () => AppNavigation.backOrHome(context),
        child: const Text('Kembali ke roster'),
      ),
    ),
  );
}

List<Route<dynamic>> generateInitialAppRoutes(String initialRoute) {
  final uri = Uri.tryParse(initialRoute);
  final routeName = uri != null && uri.hasScheme ? uri.path : initialRoute;
  return [generateAppRoute(RouteSettings(name: routeName))];
}
