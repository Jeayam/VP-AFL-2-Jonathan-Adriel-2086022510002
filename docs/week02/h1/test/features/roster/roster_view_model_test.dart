import 'package:flutter_test/flutter_test.dart';
import 'package:h1/features/roster/data/repositories/in_memory_character_repository.dart';
import 'package:h1/features/roster/viewmodels/roster_state.dart';
import 'package:h1/features/roster/viewmodels/roster_view_model.dart';

import '../../helpers/fakes.dart';
import '../../helpers/test_data.dart';

void main() {
  late FakeCharacterRepository repository;
  late RosterViewModel viewModel;

  setUp(() {
    repository = FakeCharacterRepository(characters: testCharacters);
    viewModel = RosterViewModel(repository);
    addTearDown(viewModel.dispose);
  });

  RosterLoaded loaded() => viewModel.state as RosterLoaded;
  List<String> visibleNames() =>
      viewModel.visibleCharacters.map((c) => c.name).toList();

  group('memuat roster', () {
    test('state awal adalah RosterLoading', () {
      expect(viewModel.state, const RosterLoading());
    });

    test('sukses mengubah state dari Loading ke Loaded', () async {
      final emitted = <RosterState>[];
      viewModel.addListener(() => emitted.add(viewModel.state));

      await viewModel.load();

      expect(emitted, [
        const RosterLoading(),
        const RosterLoaded(characters: testCharacters),
      ]);
    });

    test('gagal menampilkan RosterFailure dengan pesan pengguna', () async {
      repository.error = const FormatException('json rusak');

      await viewModel.load();

      expect(
        viewModel.state,
        const RosterFailure('Data karakter gagal dimuat. Coba muat ulang.'),
      );
    });

    test('data kosong menghasilkan state RosterEmpty', () async {
      repository.characters = [];

      await viewModel.load();

      expect(viewModel.state, const RosterEmpty());
    });

    test('muat ulang setelah gagal bisa pulih', () async {
      repository.error = const FormatException('json rusak');
      await viewModel.load();

      repository.error = null;
      await viewModel.load();

      expect(viewModel.state, isA<RosterLoaded>());
    });

    test('dispose saat load berjalan tidak melempar error', () async {
      final vm = RosterViewModel(repository);
      final pending = vm.load();
      vm.dispose();
      await expectLater(pending, completes);
    });
  });

  group('pencarian dan filter', () {
    setUp(() async => viewModel.load());

    test('pencarian tidak membedakan huruf besar dan kecil', () {
      viewModel.updateSearch('KAE');
      expect(visibleNames(), ['Kaelen']);
    });

    test('filter elemen', () {
      viewModel.selectElement('Fire');
      expect(visibleNames(), ['Kaelen', 'Sol']);
    });

    test('pencarian dan filter elemen dapat digunakan bersamaan', () {
      viewModel
        ..selectElement('Water')
        ..updateSearch('not found');

      expect(viewModel.visibleCharacters, isEmpty);
      viewModel.updateSearch('Aria');
      expect(visibleNames(), ['Aria']);
    });

    test('mode longTitle hanya menampilkan karakter bernama panjang', () {
      viewModel.selectPreset(RosterDataPreset.longTitle);
      expect(viewModel.visibleCharacters.map((c) => c.id), ['valerius']);
    });

    test('mode zeroItems menghasilkan daftar kosong', () {
      viewModel.selectPreset(RosterDataPreset.zeroItems);
      expect(viewModel.visibleCharacters, isEmpty);
    });

    test('mode items500 menghasilkan 500 item', () {
      viewModel.selectPreset(RosterDataPreset.items500);
      expect(viewModel.visibleCharacters, hasLength(500));
    });

    test('resetFilters mengembalikan semua pilihan ke awal', () {
      viewModel
        ..updateSearch('x')
        ..selectElement('Fire')
        ..selectPreset(RosterDataPreset.longTitle)
        ..resetFilters();

      expect(loaded().searchQuery, '');
      expect(loaded().selectedElement, 'All');
      expect(loaded().preset, RosterDataPreset.standard);
    });

    test('filter diabaikan jika state belum Loaded', () {
      final fresh = RosterViewModel(repository);
      addTearDown(fresh.dispose);
      var notified = 0;
      fresh.addListener(() => notified++);

      fresh.updateSearch('x');

      expect(fresh.state, const RosterLoading());
      expect(notified, 0);
    });
  });

  group('pergantian sumber data', () {
    test(
      'repository in-memory mengganti sumber tanpa mengubah ViewModel',
      () async {
        final swapped = RosterViewModel(const InMemoryCharacterRepository());
        addTearDown(swapped.dispose);

        await swapped.load();

        final state = swapped.state as RosterLoaded;
        expect(state.characters.map((c) => c.id), contains('kaelen'));
        expect(swapped.visibleCharacters, isNotEmpty);
      },
    );
  });
}
