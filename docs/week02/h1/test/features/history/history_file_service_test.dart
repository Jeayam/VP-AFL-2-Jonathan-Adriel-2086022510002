import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:h1/core/errors/storage_exception.dart';
import 'package:h1/features/history/data/models/history_record_model.dart';
import 'package:h1/features/history/data/services/history_file_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory temporaryDirectory;
  late File historyFile;
  late HistoryFileService historyFileService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'h1-history-test-',
    );
    historyFile = File(
      '${temporaryDirectory.path}${Platform.pathSeparator}character_history.json',
    );
    historyFileService = HistoryFileService(file: historyFile);
  });

  tearDown(() => temporaryDirectory.delete(recursive: true));

  test('menulis JSON dan dapat dibaca oleh service baru', () async {
    final first = DateTime.utc(2026, 11, 17, 8);
    final second = DateTime.utc(2026, 11, 17, 9);
    await historyFileService.saveHistory([
      HistoryRecordModel(characterId: 'kaelen', viewedAt: first),
      HistoryRecordModel(characterId: 'aria', viewedAt: second),
    ]);

    expect(await historyFile.exists(), isTrue);
    expect(jsonDecode(await historyFile.readAsString()), hasLength(2));

    final loaded = await HistoryFileService(file: historyFile).loadHistory();

    expect(loaded.map((r) => r.characterId), ['kaelen', 'aria']);
    expect(loaded.first.viewedAt.isAtSameMomentAs(first), isTrue);
  });

  test('menghapus history membersihkan semua data', () async {
    await historyFileService.saveHistory([
      HistoryRecordModel(characterId: 'kaelen', viewedAt: DateTime.utc(2026)),
    ]);

    await historyFileService.clearHistory();

    expect(await historyFileService.loadHistory(), isEmpty);
  });

  test('tanpa data mengembalikan daftar kosong', () async {
    expect(await historyFileService.loadHistory(), isEmpty);
  });

  test('data JSON rusak melempar FormatException', () async {
    await historyFile.writeAsString('{"a":1}');

    await expectLater(historyFileService.loadHistory(), throwsFormatException);
  });

  test('kegagalan menulis file melempar StorageException', () async {
    final blockingFile = File(
      '${temporaryDirectory.path}${Platform.pathSeparator}not-a-directory',
    );
    await blockingFile.writeAsString('file');
    final failingService = HistoryFileService(
      file: File(
        '${blockingFile.path}${Platform.pathSeparator}character_history.json',
      ),
    );

    await expectLater(
      failingService.saveHistory(const []),
      throwsA(isA<StorageException>()),
    );
  });

  test(
    'memigrasikan history lama dari SharedPreferences ke file JSON',
    () async {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        'character_history',
        jsonEncode([
          {
            'characterId': 'kaelen',
            'viewedAt': DateTime.utc(2026, 11, 17).toIso8601String(),
          },
        ]),
      );

      final loaded = await historyFileService.loadHistory();

      expect(loaded.single.characterId, 'kaelen');
      expect(await historyFile.exists(), isTrue);
      expect(preferences.containsKey('character_history'), isFalse);
    },
  );
}
