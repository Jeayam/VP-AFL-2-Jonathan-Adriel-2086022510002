import '../../domain/models/history_record.dart';

class HistoryService {
  const HistoryService();

  List<HistoryRecord> addViewedCharacter(
    List<HistoryRecord> records,
    String characterId, {
    DateTime? viewedAt,
  }) {
    return List.unmodifiable([
      HistoryRecord(
        characterId: characterId,
        viewedAt: viewedAt ?? DateTime.now(),
      ),
      ...records.where((record) => record.characterId != characterId),
    ]);
  }
}
