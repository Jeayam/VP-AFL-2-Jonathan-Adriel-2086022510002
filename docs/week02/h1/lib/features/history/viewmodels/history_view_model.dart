import 'package:flutter/foundation.dart';

import '../../roster/domain/models/character.dart';
import '../domain/models/history_entry.dart';
import '../domain/repositories/history_repository.dart';
import 'history_state.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryRepository repository;
  final DateTime Function() _now;
  HistoryState _state = const HistoryLoading();
  bool _disposed = false;

  HistoryViewModel(this.repository, {DateTime Function()? clock})
    : _now = clock ?? DateTime.now;

  HistoryState get state => _state;

  Future<void> load() async {
    _publish(const HistoryLoading());
    try {
      final entries = await repository.loadHistory();
      if (_disposed) return;
      _publish(entries.isEmpty ? const HistoryEmpty() : _loadedState(entries));
    } on Exception {
      if (_disposed) return;
      _publish(
        const HistoryFailure(
          'History gagal dimuat. Periksa penyimpanan lalu coba lagi.',
        ),
      );
    } on FlutterError {
      if (_disposed) return;
      _publish(
        const HistoryFailure(
          'History gagal dimuat. Periksa penyimpanan lalu coba lagi.',
        ),
      );
    }
  }

  Future<void> addViewedCharacter(Character character) async {
    // Sengaja tanpa HistoryLoading: menambah entri berjalan di latar belakang
    // dan tidak boleh membuat layar history berkedip menjadi spinner.
    try {
      final entries = await repository.addViewedCharacter(character.id);
      if (_disposed) return;
      _publish(entries.isEmpty ? const HistoryEmpty() : _loadedState(entries));
    } on Exception {
      if (_disposed) return;
      _publish(
        const HistoryFailure(
          'Karakter dilihat, tetapi gagal menyimpan history.',
        ),
      );
    } on FlutterError {
      if (_disposed) return;
      _publish(
        const HistoryFailure(
          'Karakter dilihat, tetapi gagal menyimpan history.',
        ),
      );
    }
  }

  HistoryLoaded _loadedState(List<HistoryEntry> entries) {
    final frequencies = <String, int>{};
    for (final entry in entries) {
      frequencies.update(
        entry.character.element.name,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    final mostViewedElement = frequencies.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    return HistoryLoaded(
      items: List.unmodifiable(
        entries.map(
          (entry) => HistoryItemViewData(
            entry: entry,
            viewedAtLabel: _formatViewedAt(entry.viewedAt),
          ),
        ),
      ),
      mostViewedElement: mostViewedElement,
    );
  }

  String _formatViewedAt(DateTime dateTime) {
    final local = dateTime.toLocal();
    final difference = _now().difference(local);
    if (!difference.isNegative && difference < const Duration(minutes: 1)) {
      return 'Baru saja';
    }
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
  }

  Future<bool> clearHistory() async {
    _publish(const HistoryLoading());
    try {
      await repository.clearHistory();
      if (_disposed) return false;
      _publish(const HistoryEmpty());
      return true;
    } on Exception {
      if (_disposed) return false;
      _publish(const HistoryFailure('History gagal dihapus. Coba lagi.'));
      return false;
    }
  }

  void _publish(HistoryState state) {
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
