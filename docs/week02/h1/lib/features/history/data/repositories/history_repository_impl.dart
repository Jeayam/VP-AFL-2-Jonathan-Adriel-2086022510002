import '../../../roster/domain/repositories/character_repository.dart';
import '../../domain/models/history_entry.dart';
import '../../domain/repositories/history_repository.dart';
import '../services/history_file_service.dart';
import '../services/history_service.dart';
import '../models/history_record_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryFileService historyFileService;
  final HistoryService historyService;
  final CharacterRepository characterRepository;

  /// Ekor antrean operasi. Menambah history = baca, ubah, tulis; dua operasi
  /// yang tumpang tindih saling menimpa (lost update), jadi semuanya dijalankan
  /// satu per satu sesuai urutan dipanggil.
  Future<void> _tail = Future<void>.value();

  HistoryRepositoryImpl({
    required this.historyFileService,
    required this.historyService,
    required this.characterRepository,
  });

  @override
  Future<List<HistoryEntry>> loadHistory() => _serialized(_loadEntries);

  @override
  Future<List<HistoryEntry>> addViewedCharacter(String characterId) {
    return _serialized(() async {
      final records = (await historyFileService.loadHistory())
          .map((record) => record.toEntity())
          .toList(growable: false);
      final updatedRecords = historyService.addViewedCharacter(
        records,
        characterId,
      );
      await historyFileService.saveHistory(
        updatedRecords.map(HistoryRecordModel.fromEntity).toList(),
      );
      return _loadEntries();
    });
  }

  @override
  Future<void> clearHistory() =>
      _serialized(historyFileService.clearHistory);

  Future<T> _serialized<T>(Future<T> Function() action) {
    final result = _tail.then((_) => action());
    // Kegagalan satu operasi tidak boleh memblokir antrean berikutnya.
    _tail = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  Future<List<HistoryEntry>> _loadEntries() async {
    final records = (await historyFileService.loadHistory())
        .map((record) => record.toEntity())
        .toList(growable: false);
    final characters = await characterRepository.loadCharacters();
    final charactersById = {
      for (final character in characters) character.id: character,
    };
    return records
        .where((record) => charactersById.containsKey(record.characterId))
        .map(
          (record) => HistoryEntry(
            character: charactersById[record.characterId]!,
            viewedAt: record.viewedAt,
          ),
        )
        .toList(growable: false);
  }
}
