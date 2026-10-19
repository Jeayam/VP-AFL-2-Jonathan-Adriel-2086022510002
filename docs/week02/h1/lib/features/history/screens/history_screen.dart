import 'package:flutter/material.dart';
import 'package:h1/features/history/services/history_service.dart';
import 'package:h1/features/history/widgets/history_header.dart';
import 'package:h1/features/history/widgets/history_item_tile.dart';
import 'package:h1/features/history/widgets/history_stats_card.dart';
import 'package:h1/features/roster/widgets/character_detail_dialog.dart';

class HistoryScreen extends StatelessWidget {
  final VoidCallback onBack;

  const HistoryScreen({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFEAB308)),
          onPressed: onBack,
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
      body: ValueListenableBuilder<List<Map<String, String>>>(
        valueListenable: HistoryService.historyNotifier,
        builder: (context, historyList, _) {
          if (historyList.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF131A29) : const Color(0xFFFEF3C7),
                        border: Border.all(color: const Color(0xFFEAB308), width: 1.5),
                      ),
                      child: const Icon(Icons.history_toggle_off_rounded, size: 40, color: Color(0xFFEAB308)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'NO HISTORY RECORDED',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Profiles you inspect in the Hero Codex will automatically appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black54),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: onBack,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFEAB308),
                        foregroundColor: const Color(0xFF0F172A),
                      ),
                      icon: const Icon(Icons.search_rounded, size: 16),
                      label: const Text('EXPLORE HEROES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            );
          }

          final mostElement = historyList.isNotEmpty ? (historyList.first['element'] ?? 'Fire') : 'None';

          return Column(
            children: [
              HistoryHeader(
                historyCount: historyList.length,
                onClearHistory: () => HistoryService.clearHistory(),
              ),
              HistoryStatsCard(
                totalCount: historyList.length,
                mostViewedElement: mostElement,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final char = historyList[index];
                    return HistoryItemTile(
                      character: char,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => CharacterDetailDialog(character: char),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
