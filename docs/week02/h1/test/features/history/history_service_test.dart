import 'package:flutter_test/flutter_test.dart';
import 'package:h1/features/history/domain/models/history_record.dart';
import 'package:h1/features/history/data/services/history_service.dart';

void main() {
  const service = HistoryService();

  test('menempatkan karakter terbaru di depan', () {
    final oldRecord = HistoryRecord(
      characterId: 'aria',
      viewedAt: DateTime(2026, 11, 16),
    );

    final records = service.addViewedCharacter(
      [oldRecord],
      'kaelen',
      viewedAt: DateTime(2026, 11, 17),
    );

    expect(records.map((record) => record.characterId), ['kaelen', 'aria']);
    expect(records.first.viewedAt, DateTime(2026, 11, 17));
  });

  test('menghapus rekaman karakter lama sebelum menambah rekaman terbaru', () {
    final records = service.addViewedCharacter(
      [
        HistoryRecord(
          characterId: 'aria',
          viewedAt: DateTime(2026, 11, 16),
        ),
        HistoryRecord(
          characterId: 'kaelen',
          viewedAt: DateTime(2026, 11, 15),
        ),
      ],
      'aria',
      viewedAt: DateTime(2026, 11, 17),
    );

    expect(records.map((record) => record.characterId), ['aria', 'kaelen']);
    expect(records.first.viewedAt, DateTime(2026, 11, 17));
  });

  test('tidak mengubah daftar lama saat menambah rekaman', () {
    final original = [
      HistoryRecord(
        characterId: 'aria',
        viewedAt: DateTime(2026, 11, 16),
      ),
    ];

    service.addViewedCharacter(
      original,
      'kaelen',
      viewedAt: DateTime(2026, 11, 17),
    );

    expect(original, hasLength(1));
    expect(original.single.characterId, 'aria');
  });
}
