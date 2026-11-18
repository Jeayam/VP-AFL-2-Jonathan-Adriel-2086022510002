import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:h1/features/history/domain/models/history_entry.dart';
import 'package:h1/features/history/domain/repositories/history_repository.dart';
import 'package:h1/features/roster/domain/models/character.dart';
import 'package:h1/features/roster/domain/models/element.dart' as domain;
import 'package:h1/features/roster/domain/models/role.dart';
import 'package:h1/features/settings/domain/repositories/settings_repository.dart';
import 'package:h1/main.dart';

import 'helpers/fakes.dart';
import 'helpers/test_data.dart';

void main() {
  testWidgets('aplikasi menampilkan roster pada layar ponsel', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const character = Character(
      id: 'hero',
      name: 'Test Hero',
      imageUrl: '',
      element: domain.Element(id: 'fire', name: 'Fire'),
      role: Role(id: 'dps', name: 'DPS'),
    );
    await tester.pumpWidget(
      MyApp(
        characterRepository: FakeCharacterRepository(characters: [character]),
        historyRepository: _FakeHistoryRepository(),
        settingsRepository: _FakeSettingsRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('HERO CODEX'), findsOneWidget);
    expect(find.text('Test Hero'), findsOneWidget);
  });

  testWidgets('deep link detail karakter punya navigasi kembali', (
    tester,
  ) async {
    const character = Character(
      id: 'hero',
      name: 'Test Hero',
      imageUrl: '',
      element: domain.Element(id: 'fire', name: 'Fire'),
      role: Role(id: 'dps', name: 'DPS'),
    );
    await tester.pumpWidget(
      MyApp(
        initialRoute: 'herocodex://app/characters/hero',
        characterRepository: FakeCharacterRepository(characters: [character]),
        historyRepository: _FakeHistoryRepository(),
        settingsRepository: _FakeSettingsRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test Hero'), findsOneWidget);
    await tester.tap(find.text('CLOSE ARCHIVE'));
    await tester.pumpAndSettle();

    expect(find.text('HERO CODEX'), findsOneWidget);
  });

  testWidgets('membuka dan menutup detail mempertahankan halaman asal', (
    tester,
  ) async {
    const character = Character(
      id: 'hero',
      name: 'Test Hero',
      imageUrl: '',
      element: domain.Element(id: 'fire', name: 'Fire'),
      role: Role(id: 'dps', name: 'DPS'),
    );
    await tester.pumpWidget(
      MyApp(
        characterRepository: FakeCharacterRepository(characters: [character]),
        historyRepository: _FakeHistoryRepository(),
        settingsRepository: _FakeSettingsRepository(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Test Hero'));
    await tester.pumpAndSettle();
    expect(find.text('CLOSE ARCHIVE'), findsOneWidget);

    await tester.tap(find.text('CLOSE ARCHIVE'));
    await tester.pumpAndSettle();
    expect(find.text('HERO CODEX'), findsOneWidget);
  });

  testWidgets('navigasi history kembali ke roster', (tester) async {
    await tester.pumpWidget(
      MyApp(
        characterRepository: FakeCharacterRepository(characters: [kaelen]),
        historyRepository: _FakeHistoryRepository(),
        settingsRepository: _FakeSettingsRepository(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('History').last);
    await tester.pumpAndSettle();
    expect(find.text('VIEW HISTORY'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.text('HERO CODEX'), findsOneWidget);
  });

  testWidgets('history diperbarui setelah kembali dari detail karakter', (
    tester,
  ) async {
    final historyRepository = FakeHistoryRepository(
      initial: [
        HistoryEntry(character: kaelen, viewedAt: DateTime(2026, 11, 17)),
        HistoryEntry(character: aria, viewedAt: DateTime(2026, 11, 16)),
      ],
      knownCharacters: [kaelen, aria],
    );
    await tester.pumpWidget(
      MyApp(
        characterRepository: FakeCharacterRepository(
          characters: [kaelen, aria],
        ),
        historyRepository: historyRepository,
        settingsRepository: _FakeSettingsRepository(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('History').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aria'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CLOSE ARCHIVE'));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('Aria')).dy,
      lessThan(tester.getTopLeft(find.text('Kaelen')).dy),
    );
  });

  testWidgets('roster kosong menampilkan empty state dan retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      MyApp(
        characterRepository: FakeCharacterRepository(),
        historyRepository: _FakeHistoryRepository(),
        settingsRepository: _FakeSettingsRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada data karakter.'), findsOneWidget);
    expect(find.text('Coba lagi'), findsOneWidget);
  });
}

class _FakeHistoryRepository implements HistoryRepository {
  @override
  Future<List<HistoryEntry>> addViewedCharacter(String characterId) async => [];

  @override
  Future<void> clearHistory() async {}

  @override
  Future<List<HistoryEntry>> loadHistory() async => [];
}

class _FakeSettingsRepository implements SettingsRepository {
  @override
  Future<bool> loadDarkMode() async => true;

  @override
  Future<void> saveDarkMode(bool enabled) async {}
}
