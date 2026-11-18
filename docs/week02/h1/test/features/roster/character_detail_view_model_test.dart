import 'package:flutter_test/flutter_test.dart';
import 'package:h1/core/errors/storage_exception.dart';
import 'package:h1/features/roster/viewmodels/character_detail_state.dart';
import 'package:h1/features/roster/viewmodels/character_detail_view_model.dart';

import '../../helpers/fakes.dart';
import '../../helpers/test_data.dart';

void main() {
  test('memuat karakter berdasarkan ID dan mencatatnya ke history', () async {
    final characterRepository = FakeCharacterRepository(
      characters: testCharacters,
    );
    final historyRepository = FakeHistoryRepository(
      knownCharacters: testCharacters,
    );
    final viewModel = CharacterDetailViewModel(
      characterId: 'kaelen',
      characterRepository: characterRepository,
      historyRepository: historyRepository,
    );
    addTearDown(viewModel.dispose);

    await viewModel.load();

    final state = viewModel.state as CharacterDetailLoaded;
    expect(state.character.id, 'kaelen');
    expect(historyRepository.entries.single.character.id, 'kaelen');
    expect(state.stats.first.percentageLabel, '88%');
  });

  test('ID yang tidak ditemukan tidak dicatat ke history', () async {
    final historyRepository = FakeHistoryRepository(
      knownCharacters: testCharacters,
    );
    final viewModel = CharacterDetailViewModel(
      characterId: 'unknown',
      characterRepository: FakeCharacterRepository(
        characters: testCharacters,
      ),
      historyRepository: historyRepository,
    );
    addTearDown(viewModel.dispose);

    await viewModel.load();

    expect(viewModel.state, const CharacterDetailNotFound());
    expect(historyRepository.entries, isEmpty);
  });

  test('kegagalan menyimpan history tidak menyembunyikan detail karakter', () async {
    final historyRepository = FakeHistoryRepository(
      knownCharacters: testCharacters,
      error: const StorageException('gagal tulis'),
    );
    final viewModel = CharacterDetailViewModel(
      characterId: 'kaelen',
      characterRepository: FakeCharacterRepository(
        characters: testCharacters,
      ),
      historyRepository: historyRepository,
    );
    addTearDown(viewModel.dispose);

    await viewModel.load();

    final state = viewModel.state as CharacterDetailLoaded;
    expect(state.character.id, 'kaelen');
    expect(state.historyMessage, isNotNull);
  });

  test('kegagalan memuat karakter menghasilkan pesan error', () async {
    final viewModel = CharacterDetailViewModel(
      characterId: 'kaelen',
      characterRepository: FakeCharacterRepository(
        error: const FormatException('json rusak'),
      ),
      historyRepository: FakeHistoryRepository(
        knownCharacters: testCharacters,
      ),
    );
    addTearDown(viewModel.dispose);

    await viewModel.load();

    expect(
      viewModel.state,
      const CharacterDetailFailure(
        'Data karakter gagal dimuat. Coba muat ulang.',
      ),
    );
  });
}
