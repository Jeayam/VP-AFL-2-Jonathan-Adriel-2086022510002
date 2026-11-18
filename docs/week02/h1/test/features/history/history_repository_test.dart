import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:h1/features/history/data/repositories/history_repository_impl.dart';
import 'package:h1/features/history/data/services/history_file_service.dart';
import 'package:h1/features/history/data/services/history_service.dart';

import '../../helpers/fakes.dart';
import '../../helpers/test_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HistoryRepositoryImpl repository;
  late Directory temporaryDirectory;
  late File historyFile;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'h1-history-repository-test-',
    );
    historyFile = File(
      '${temporaryDirectory.path}${Platform.pathSeparator}character_history.json',
    );
    repository = HistoryRepositoryImpl(
      historyFileService: HistoryFileService(file: historyFile),
      historyService: const HistoryService(),
      characterRepository: FakeCharacterRepository(
        characters: testHistoryCharacters,
      ),
    );
  });

  tearDown(() => temporaryDirectory.delete(recursive: true));

  test(
    'history tersimpan dan dapat dibaca setelah repository dibuat ulang',
    () async {
      await repository.addViewedCharacter(testHistoryCharacter.id);
      final reopenedRepository = HistoryRepositoryImpl(
        historyFileService: HistoryFileService(file: historyFile),
        historyService: const HistoryService(),
        characterRepository: FakeCharacterRepository(
          characters: testHistoryCharacters,
        ),
      );

      final entries = await reopenedRepository.loadHistory();
      expect(entries, hasLength(1));
      expect(entries.single.character, testHistoryCharacter);
    },
  );

  test(
    'melihat karakter yang sama memindahkannya ke depan tanpa duplikat',
    () async {
      await repository.addViewedCharacter(testHistoryCharacter.id);
      await repository.addViewedCharacter(testHistoryCharacter.id);

      expect(await repository.loadHistory(), hasLength(1));
    },
  );

  test(
    'ketukan bersamaan tersimpan sesuai urutan tanpa kehilangan entri',
    () async {
      final results = await Future.wait([
        repository.addViewedCharacter('kaelen'),
        repository.addViewedCharacter('aria'),
        repository.addViewedCharacter('sol'),
      ]);

      expect(results.last.map((entry) => entry.character.id), [
        'sol',
        'aria',
        'kaelen',
      ]);
      expect(
        (await repository.loadHistory()).map((entry) => entry.character.id),
        ['sol', 'aria', 'kaelen'],
      );
    },
  );

  test('tambah dan hapus history berjalan sesuai urutan pemanggilan', () async {
    final addBeforeClear = repository.addViewedCharacter('kaelen');
    final clear = repository.clearHistory();
    final addAfterClear = repository.addViewedCharacter('aria');

    await Future.wait([addBeforeClear, clear, addAfterClear]);

    expect(
      (await repository.loadHistory()).map((entry) => entry.character.id),
      ['aria'],
    );
  });

  test('menghapus history menghilangkan data tersimpan', () async {
    await repository.addViewedCharacter(testHistoryCharacter.id);
    await repository.clearHistory();

    expect(await repository.loadHistory(), isEmpty);
  });
}
