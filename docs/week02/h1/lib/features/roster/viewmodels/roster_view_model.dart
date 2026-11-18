import 'package:flutter/foundation.dart';

import '../domain/models/character.dart';
import '../domain/repositories/character_repository.dart';
import 'roster_state.dart';

class RosterViewModel extends ChangeNotifier {
  final CharacterRepository repository;
  RosterState _state = const RosterLoading();
  bool _disposed = false;

  RosterViewModel(this.repository);

  RosterState get state => _state;

  List<String> get availableElements {
    final current = _state;
    if (current is! RosterLoaded) return const ['All'];
    return [
      'All',
      ...current.characters.map((character) => character.element.name).toSet(),
    ];
  }

  List<Character> get visibleCharacters {
    final current = _state;
    if (current is! RosterLoaded) return const [];

    final standardCharacters = current.characters
        .where((character) => character.name.length <= 40)
        .toList(growable: false);
    final presetCharacters = switch (current.preset) {
      RosterDataPreset.standard => standardCharacters,
      RosterDataPreset.longTitle => current.characters
          .where((character) => character.name.length > 40)
          .toList(growable: false),
      RosterDataPreset.zeroItems => const <Character>[],
      RosterDataPreset.items500 =>
        standardCharacters.isEmpty
            ? const <Character>[]
            : List.generate(500, (index) {
                final source =
                    standardCharacters[index % standardCharacters.length];
                return source.copyWith(
                  id: 'harness-${index + 1}',
                  name:
                      'Hero #${index + 1} - ${source.role.name} of the ${source.element.name} Order',
                );
              }, growable: false),
    };

    return presetCharacters
        .where((character) {
          final matchesSearch = character.name.toLowerCase().contains(
            current.searchQuery.toLowerCase(),
          );
          final matchesElement =
              current.selectedElement == 'All' ||
              character.element.name == current.selectedElement;
          return matchesSearch && matchesElement;
        })
        .toList(growable: false);
  }

  Future<void> load() async {
    _publish(const RosterLoading());
    try {
      final characters = await repository.loadCharacters();
      if (_disposed) return;
      _publish(
        characters.isEmpty
            ? const RosterEmpty()
            : RosterLoaded(characters: List.unmodifiable(characters)),
      );
    } on Exception {
      if (_disposed) return;
      _publish(
        const RosterFailure('Data karakter gagal dimuat. Coba muat ulang.'),
      );
    } on FlutterError {
      if (_disposed) return;
      _publish(
        const RosterFailure('Data karakter gagal dimuat. Coba muat ulang.'),
      );
    }
  }

  void updateSearch(String query) {
    final current = _state;
    if (current is RosterLoaded) {
      _publish(current.copyWith(searchQuery: query));
    }
  }

  void selectElement(String element) {
    final current = _state;
    if (current is RosterLoaded) {
      _publish(current.copyWith(selectedElement: element));
    }
  }

  void selectPreset(RosterDataPreset preset) {
    final current = _state;
    if (current is RosterLoaded) {
      _publish(current.copyWith(preset: preset));
    }
  }

  void resetFilters() {
    final current = _state;
    if (current is RosterLoaded) {
      _publish(
        current.copyWith(
          searchQuery: '',
          selectedElement: 'All',
          preset: RosterDataPreset.standard,
        ),
      );
    }
  }

  void _publish(RosterState state) {
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
