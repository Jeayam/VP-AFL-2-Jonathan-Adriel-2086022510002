import 'package:equatable/equatable.dart';

import '../domain/models/history_entry.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();
}

final class HistoryItemViewData extends Equatable {
  final HistoryEntry entry;
  final String viewedAtLabel;

  const HistoryItemViewData({
    required this.entry,
    required this.viewedAtLabel,
  });

  @override
  List<Object?> get props => [entry, viewedAtLabel];
}

final class HistoryLoading extends HistoryState {
  const HistoryLoading();

  @override
  List<Object?> get props => [];
}

final class HistoryEmpty extends HistoryState {
  const HistoryEmpty();

  @override
  List<Object?> get props => [];
}

final class HistoryLoaded extends HistoryState {
  final List<HistoryItemViewData> items;
  final String mostViewedElement;

  const HistoryLoaded({
    required this.items,
    required this.mostViewedElement,
  });

  int get totalCount => items.length;

  @override
  List<Object?> get props => [items, mostViewedElement];
}

final class HistoryFailure extends HistoryState {
  final String message;

  const HistoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
