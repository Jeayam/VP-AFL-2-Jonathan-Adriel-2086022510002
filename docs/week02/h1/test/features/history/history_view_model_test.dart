import 'package:flutter_test/flutter_test.dart';
import 'package:h1/core/errors/storage_exception.dart';
import 'package:h1/features/history/domain/models/history_entry.dart';
import 'package:h1/features/history/viewmodels/history_state.dart';
import 'package:h1/features/history/viewmodels/history_view_model.dart';

import '../../helpers/fakes.dart';
import '../../helpers/test_data.dart';

void main() {
  late FakeHistoryRepository repository;
  late HistoryViewModel viewModel;

  setUp(() {
    repository = FakeHistoryRepository(knownCharacters: testCharacters);
    viewModel = HistoryViewModel(repository);
    addTearDown(viewModel.dispose);
  });

  List<String> loadedIds() => (viewModel.state as HistoryLoaded).items
      .map((item) => item.entry)
      .map((entry) => entry.character.id)
      .toList();

  group('memuat history', () {
    test('kosong menghasilkan HistoryEmpty', () async {
      await viewModel.load();
      expect(viewModel.state, const HistoryEmpty());
    });

    test('berisi menghasilkan HistoryLoaded', () async {
      repository = FakeHistoryRepository(
        initial: [
          HistoryEntry(character: kaelen, viewedAt: DateTime(2026, 11, 17)),
        ],
      );
      final vm = HistoryViewModel(repository);
      addTearDown(vm.dispose);

      await vm.load();

      expect(
        (vm.state as HistoryLoaded).items.single.entry.character,
        kaelen,
      );
    });

    test('gagal menghasilkan HistoryFailure dengan pesan pengguna', () async {
      repository.error = const FormatException('rusak');

      await viewModel.load();

      expect(
        viewModel.state,
        const HistoryFailure(
          'History gagal dimuat. Periksa penyimpanan lalu coba lagi.',
        ),
      );
    });

    test('menyiapkan ringkasan dan label tanggal untuk View', () async {
      final now = DateTime(2026, 11, 17, 10);
      repository = FakeHistoryRepository(
        initial: [
          HistoryEntry(
            character: kaelen,
            viewedAt: now.subtract(const Duration(seconds: 20)),
          ),
          HistoryEntry(
            character: sol,
            viewedAt: DateTime(2026, 11, 16, 8),
          ),
          HistoryEntry(
            character: aria,
            viewedAt: DateTime(2026, 11, 16, 7),
          ),
        ],
      );
      final vm = HistoryViewModel(repository, clock: () => now);
      addTearDown(vm.dispose);

      await vm.load();

      final state = vm.state as HistoryLoaded;
      expect(state.totalCount, 3);
      expect(state.mostViewedElement, 'Fire');
      expect(
        state.items.map((item) => item.viewedAtLabel),
        ['Baru saja', '16/11/2026', '16/11/2026'],
      );
    });
  });

  group('menambah karakter ke history', () {
    test('tidak mengirim HistoryLoading saat menambah entri', () async {
      final emitted = <HistoryState>[];
      viewModel.addListener(() => emitted.add(viewModel.state));

      await viewModel.addViewedCharacter(kaelen);

      expect(emitted, hasLength(1));
      expect(emitted.single, isA<HistoryLoaded>());
      expect(emitted, isNot(contains(isA<HistoryLoading>())));
    });

    test('karakter terbaru ada di urutan pertama tanpa duplikat', () async {
      await viewModel.addViewedCharacter(kaelen);
      await viewModel.addViewedCharacter(aria);
      expect(loadedIds(), ['aria', 'kaelen']);

      await viewModel.addViewedCharacter(kaelen);
      expect(loadedIds(), ['kaelen', 'aria']);
    });

    test(
      'gagal simpan (StorageException) menjadi HistoryFailure, bukan crash',
      () async {
        repository.error = const StorageException('disk penuh');

        await viewModel.addViewedCharacter(kaelen);

        expect(
          viewModel.state,
          const HistoryFailure(
            'Karakter dilihat, tetapi gagal menyimpan history.',
          ),
        );
      },
    );
  });

  group('menghapus history', () {
    test('sukses mengembalikan true dan HistoryEmpty', () async {
      await viewModel.addViewedCharacter(kaelen);

      final result = await viewModel.clearHistory();

      expect(result, isTrue);
      expect(viewModel.state, const HistoryEmpty());
    });

    test('gagal mengembalikan false dan HistoryFailure', () async {
      repository.error = const StorageException('tidak bisa menghapus');

      final result = await viewModel.clearHistory();

      expect(result, isFalse);
      expect(
        viewModel.state,
        const HistoryFailure('History gagal dihapus. Coba lagi.'),
      );
    });
  });
}
