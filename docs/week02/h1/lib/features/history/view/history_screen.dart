import 'package:flutter/material.dart';

import '../viewmodels/history_state.dart';
import '../viewmodels/history_view_model.dart';
import '../../roster/domain/models/character.dart';
import 'widgets/history_header.dart';
import 'widgets/history_item_tile.dart';
import 'widgets/history_stats_card.dart';

class HistoryScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<Character> onCharacterSelected;
  final HistoryViewModel viewModel;

  const HistoryScreen({
    super.key,
    required this.onBack,
    required this.onCharacterSelected,
    required this.viewModel,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFEAB308)),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'VIEW HISTORY',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 15,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) => switch (widget.viewModel.state) {
          HistoryLoading() => const Center(child: CircularProgressIndicator()),
          HistoryFailure(:final message) => _HistoryError(
            message: message,
            onRetry: widget.viewModel.load,
          ),
          HistoryEmpty() => _HistoryEmpty(
            isDark: isDark,
            onBack: widget.onBack,
          ),
          HistoryLoaded(
            :final items,
            :final totalCount,
            :final mostViewedElement,
          ) => _HistoryList(
            items: items,
            totalCount: totalCount,
            mostViewedElement: mostViewedElement,
            isDark: isDark,
            onClear: widget.viewModel.clearHistory,
            onCharacterSelected: widget.onCharacterSelected,
          ),
        },
      ),
    );
  }
}

class _HistoryError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _HistoryError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 36),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    ),
  );
}

class _HistoryEmpty extends StatelessWidget {
  final bool isDark;
  final VoidCallback onBack;

  const _HistoryEmpty({required this.isDark, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF131A29)
                    : const Color(0xFFFEF3C7),
                border: Border.all(color: const Color(0xFFEAB308), width: 1.5),
              ),
              child: const Icon(
                Icons.history_toggle_off_rounded,
                size: 40,
                color: Color(0xFFEAB308),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'BELUM ADA HISTORY',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black87,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Karakter yang kamu lihat akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onBack,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFEAB308),
                foregroundColor: const Color(0xFF0F172A),
              ),
              icon: const Icon(Icons.search_rounded, size: 16),
              label: const Text('JELAJAHI KARAKTER'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<HistoryItemViewData> items;
  final int totalCount;
  final String mostViewedElement;
  final bool isDark;
  final VoidCallback onClear;
  final ValueChanged<Character> onCharacterSelected;

  const _HistoryList({
    required this.items,
    required this.totalCount,
    required this.mostViewedElement,
    required this.isDark,
    required this.onClear,
    required this.onCharacterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HistoryHeader(historyCount: totalCount, onClearHistory: onClear),
        HistoryStatsCard(
          totalCount: totalCount,
          mostViewedElement: mostViewedElement,
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return HistoryItemTile(
                item: item,
                onTap: () => onCharacterSelected(item.entry.character),
              );
            },
          ),
        ),
      ],
    );
  }
}
