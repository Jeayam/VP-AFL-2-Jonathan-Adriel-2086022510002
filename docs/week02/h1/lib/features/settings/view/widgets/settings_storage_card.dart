import 'package:flutter/material.dart';

class SettingsStorageCard extends StatelessWidget {
  final Future<bool> Function() onClearHistory;

  const SettingsStorageCard({super.key, required this.onClearHistory});

  Future<void> _showResetConfirmDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus history karakter?'),
        content: const Text(
          'History karakter yang tersimpan di perangkat akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await onClearHistory();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'History berhasil dihapus.'
                        : 'History gagal dihapus. Coba lagi.',
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('HAPUS'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101726) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () => _showResetConfirmDialog(context),
          leading: const Icon(
            Icons.cleaning_services_rounded,
            color: Color(0xFFEF4444),
          ),
          title: Text(
            'Hapus History',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: const Text(
            'Hapus daftar karakter yang pernah dilihat',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
