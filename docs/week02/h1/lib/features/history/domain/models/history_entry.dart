import 'package:equatable/equatable.dart';

import '../../../roster/domain/models/character.dart';

class HistoryEntry extends Equatable {
  final Character character;
  final DateTime viewedAt;

  const HistoryEntry({required this.character, required this.viewedAt});

  @override
  List<Object?> get props => [character, viewedAt];
}
