import '../models/history_entry.dart';

abstract interface class HistoryRepository {
  Future<List<HistoryEntry>> loadHistory();

  Future<List<HistoryEntry>> addViewedCharacter(String characterId);

  Future<void> clearHistory();
}
