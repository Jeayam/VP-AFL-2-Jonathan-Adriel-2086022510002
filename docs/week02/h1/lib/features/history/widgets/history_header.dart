import 'package:flutter/material.dart';

class HistoryHeader extends StatelessWidget {
  final int historyCount;
  final VoidCallback onClearHistory;

  const HistoryHeader({
    super.key,
    required this.historyCount,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101726).withValues(alpha: 0.92) : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.history_rounded, size: 18, color: Color(0xFFEAB308)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'RECENTLY VIEWED ($historyCount)',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFEAB308),
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (historyCount > 0) ...[
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: onClearHistory,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                visualDensity: VisualDensity.compact,
              ),
              icon: const Icon(Icons.delete_outline_rounded, size: 15),
              label: const Text('CLEAR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }
}
