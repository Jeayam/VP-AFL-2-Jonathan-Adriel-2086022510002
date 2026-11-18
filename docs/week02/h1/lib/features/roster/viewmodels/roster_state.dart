import 'package:equatable/equatable.dart';

import '../domain/models/character.dart';

enum RosterDataPreset { standard, longTitle, zeroItems, items500 }

sealed class RosterState extends Equatable {
  const RosterState();
}

final class RosterLoading extends RosterState {
  const RosterLoading();

  @override
  List<Object?> get props => [];
}

final class RosterFailure extends RosterState {
  final String message;

  const RosterFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class RosterEmpty extends RosterState {
  const RosterEmpty();

  @override
  List<Object?> get props => [];
}

final class RosterLoaded extends RosterState {
  final List<Character> characters;
  final String searchQuery;
  final String selectedElement;
  final RosterDataPreset preset;

  const RosterLoaded({
    required this.characters,
    this.searchQuery = '',
    this.selectedElement = 'All',
    this.preset = RosterDataPreset.standard,
  });

  RosterLoaded copyWith({
    String? searchQuery,
    String? selectedElement,
    RosterDataPreset? preset,
  }) {
    return RosterLoaded(
      characters: characters,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedElement: selectedElement ?? this.selectedElement,
      preset: preset ?? this.preset,
    );
  }

  @override
  List<Object?> get props => [characters, searchQuery, selectedElement, preset];
}
