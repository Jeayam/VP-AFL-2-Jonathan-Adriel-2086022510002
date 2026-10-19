import 'package:flutter/material.dart';

class HistoryItemTile extends StatelessWidget {
  final Map<String, String> character;
  final VoidCallback onTap;

  const HistoryItemTile({
    super.key,
    required this.character,
    required this.onTap,
  });

  Color _getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return const Color(0xFFEF4444);
      case 'water':
        return const Color(0xFF38BDF8);
      case 'lightning':
        return const Color(0xFFFBBF24);
      case 'dark':
        return const Color(0xFFA855F7);
      default:
        return const Color(0xFFEAB308);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final element = character['element'] ?? 'Fire';
    final role = character['role'] ?? 'Hero';
    final name = character['name'] ?? '';
    final viewedAt = character['viewedAt'] ?? 'Just now';
    final elementColor = _getElementColor(element);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101726) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Image.asset(
                character['imageUrl'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: elementColor.withValues(alpha: 0.2),
                  child: Icon(Icons.shield, size: 20, color: elementColor),
                ),
              ),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: elementColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$element • $role',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: elementColor),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                viewedAt,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFEAB308)),
        ),
      ),
    );
  }
}
