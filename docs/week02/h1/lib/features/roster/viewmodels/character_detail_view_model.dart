import 'package:flutter/foundation.dart';

import '../domain/models/character.dart';
import '../domain/repositories/character_repository.dart';
import '../../history/domain/repositories/history_repository.dart';
import 'character_detail_state.dart';

class CharacterDetailViewModel extends ChangeNotifier {
  static const _stats = [
    CharacterDetailStat(
      label: 'ATK POWER',
      value: 0.88,
      percentageLabel: '88%',
      tone: CharacterStatTone.attack,
    ),
    CharacterDetailStat(
      label: 'MAX HEALTH',
      value: 0.76,
      percentageLabel: '76%',
      tone: CharacterStatTone.health,
    ),
    CharacterDetailStat(
      label: 'CRIT RATE',
      value: 0.65,
      percentageLabel: '65%',
      tone: CharacterStatTone.critical,
    ),
  ];

  final String characterId;
  final CharacterRepository characterRepository;
  final HistoryRepository historyRepository;
  CharacterDetailState _state = const CharacterDetailLoading();
  bool _disposed = false;

  CharacterDetailViewModel({
    required this.characterId,
    required this.characterRepository,
    required this.historyRepository,
  });

  CharacterDetailState get state => _state;

  Future<void> load() async {
    _publish(const CharacterDetailLoading());

    late final Character character;
    try {
      final characters = await characterRepository.loadCharacters();
      if (_disposed) return;

      Character? match;
      for (final item in characters) {
        if (item.id == characterId) {
          match = item;
          break;
        }
      }
      if (match == null) {
        _publish(const CharacterDetailNotFound());
        return;
      }
      character = match;
    } on Exception {
      if (_disposed) return;
      _publish(
        const CharacterDetailFailure(
          'Data karakter gagal dimuat. Coba muat ulang.',
        ),
      );
      return;
    } on FlutterError {
      if (_disposed) return;
      _publish(
        const CharacterDetailFailure(
          'Data karakter gagal dimuat. Coba muat ulang.',
        ),
      );
      return;
    }

    _publish(
      CharacterDetailLoaded(character: character, stats: _stats),
    );
    try {
      await historyRepository.addViewedCharacter(character.id);
      if (_disposed) return;
    } on Exception {
      if (_disposed) return;
      _publish(
        CharacterDetailLoaded(
          character: character,
          stats: _stats,
          historyMessage: 'Karakter dibuka, tetapi gagal menyimpan history.',
        ),
      );
    }
  }

  void _publish(CharacterDetailState state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
