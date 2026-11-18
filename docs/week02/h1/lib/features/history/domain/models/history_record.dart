import 'package:equatable/equatable.dart';

class HistoryRecord extends Equatable {
  final String characterId;
  final DateTime viewedAt;

  const HistoryRecord({required this.characterId, required this.viewedAt});

  @override
  List<Object?> get props => [characterId, viewedAt];
}
