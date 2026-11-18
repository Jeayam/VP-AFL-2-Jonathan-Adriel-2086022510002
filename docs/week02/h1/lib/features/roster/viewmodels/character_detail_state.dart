import 'package:equatable/equatable.dart';

import '../domain/models/character.dart';

enum CharacterStatTone { attack, health, critical }

final class CharacterDetailStat extends Equatable {
  final String label;
  final double value;
  final String percentageLabel;
  final CharacterStatTone tone;

  const CharacterDetailStat({
    required this.label,
    required this.value,
    required this.percentageLabel,
    required this.tone,
  });

  @override
  List<Object?> get props => [label, value, percentageLabel, tone];
}

sealed class CharacterDetailState extends Equatable {
  const CharacterDetailState();
}

final class CharacterDetailLoading extends CharacterDetailState {
  const CharacterDetailLoading();

  @override
  List<Object?> get props => [];
}

final class CharacterDetailNotFound extends CharacterDetailState {
  const CharacterDetailNotFound();

  @override
  List<Object?> get props => [];
}

final class CharacterDetailFailure extends CharacterDetailState {
  final String message;

  const CharacterDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class CharacterDetailLoaded extends CharacterDetailState {
  final Character character;
  final List<CharacterDetailStat> stats;
  final String? historyMessage;

  const CharacterDetailLoaded({
    required this.character,
    required this.stats,
    this.historyMessage,
  });

  @override
  List<Object?> get props => [character, stats, historyMessage];
}
