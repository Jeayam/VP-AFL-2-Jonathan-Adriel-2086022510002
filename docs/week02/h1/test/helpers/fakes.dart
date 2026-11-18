import 'package:h1/features/history/domain/models/history_entry.dart';
import 'package:h1/features/history/domain/repositories/history_repository.dart';
import 'package:h1/features/roster/domain/models/character.dart';
import 'package:h1/features/roster/domain/repositories/character_repository.dart';
import 'package:h1/features/settings/domain/repositories/settings_repository.dart';

/// Isi [error] dengan exception apa pun untuk mensimulasikan kegagalan.
class FakeCharacterRepository implements CharacterRepository {
  FakeCharacterRepository({this.characters = const [], this.error});

  List<Character> characters;
  Object? error;

  @override
  Future<List<Character>> loadCharacters() async {
    final failure = error;
    if (failure != null) throw failure;
    return characters;
  }
}

class FakeHistoryRepository implements HistoryRepository {
  FakeHistoryRepository({
    List<HistoryEntry> initial = const [],
    this.knownCharacters = const [],
    this.error,
  }) : entries = [...initial];

  final List<Character> knownCharacters;
  final List<HistoryEntry> entries;
  Object? error;

  void _failIfNeeded() {
    final failure = error;
    if (failure != null) throw failure;
  }

  @override
  Future<List<HistoryEntry>> loadHistory() async {
    _failIfNeeded();
    return List.of(entries);
  }

  @override
  Future<List<HistoryEntry>> addViewedCharacter(String characterId) async {
    _failIfNeeded();
    final character = knownCharacters.firstWhere((c) => c.id == characterId);
    entries.removeWhere((entry) => entry.character.id == characterId);
    entries.insert(
      0,
      HistoryEntry(character: character, viewedAt: DateTime(2026, 11, 17)),
    );
    return List.of(entries);
  }

  @override
  Future<void> clearHistory() async {
    _failIfNeeded();
    entries.clear();
  }
}

class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({
    this.darkMode = true,
    this.loadError,
    this.saveError,
  });

  bool darkMode;
  Object? loadError;
  Object? saveError;
  final List<bool> saved = [];

  @override
  Future<bool> loadDarkMode() async {
    final failure = loadError;
    if (failure != null) throw failure;
    return darkMode;
  }

  @override
  Future<void> saveDarkMode(bool enabled) async {
    final failure = saveError;
    if (failure != null) throw failure;
    darkMode = enabled;
    saved.add(enabled);
  }
}
