import '../../domain/models/history_record.dart';

class HistoryRecordModel {
  final String characterId;
  final DateTime viewedAt;

  const HistoryRecordModel({required this.characterId, required this.viewedAt});

  factory HistoryRecordModel.fromJson(Map<String, dynamic> json) {
    final characterId = json['characterId'];
    final viewedAt = json['viewedAt'];
    if (characterId is! String || characterId.isEmpty || viewedAt is! String) {
      throw const FormatException('Format data history tidak valid.');
    }

    final parsedDate = DateTime.tryParse(viewedAt);
    if (parsedDate == null) {
      throw const FormatException('Waktu pada data history tidak valid.');
    }

    return HistoryRecordModel(characterId: characterId, viewedAt: parsedDate);
  }

  factory HistoryRecordModel.fromEntity(HistoryRecord record) {
    return HistoryRecordModel(
      characterId: record.characterId,
      viewedAt: record.viewedAt,
    );
  }

  HistoryRecord toEntity() =>
      HistoryRecord(characterId: characterId, viewedAt: viewedAt);

  Map<String, String> toJson() => {
    'characterId': characterId,
    'viewedAt': viewedAt.toIso8601String(),
  };
}
