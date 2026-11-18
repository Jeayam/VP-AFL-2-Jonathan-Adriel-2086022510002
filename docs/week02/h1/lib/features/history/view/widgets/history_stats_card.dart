import 'package:flutter/material.dart';

class HistoryStatsCard extends StatelessWidget {
  final int totalCount;
  final String mostViewedElement;

  const HistoryStatsCard({
    super.key,
    required this.totalCount,
    required this.mostViewedElement,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFFEF3C7), const Color(0xFFFFFBEB)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFEAB308).withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatPill('TOTAL VIEWED', '$totalCount Heroes', isDark)),
          Container(width: 1, height: 28, color: Colors.grey.withValues(alpha: 0.3)),
          Expanded(child: _buildStatPill('FAV AFFINITY', mostViewedElement.toUpperCase(), isDark)),
        ],
      ),
    );
  }

  Widget _buildStatPill(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF78350F),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: isDark ? const Color(0xFFEAB308) : const Color(0xFFB45309),
          ),
        ),
      ],
    );
  }
}
