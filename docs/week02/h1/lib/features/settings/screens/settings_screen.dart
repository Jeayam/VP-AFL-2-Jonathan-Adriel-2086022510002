import 'package:flutter/material.dart';
import 'package:h1/features/settings/widgets/settings_header_tile.dart';
import 'package:h1/features/settings/widgets/settings_storage_card.dart';
import 'package:h1/features/settings/widgets/settings_theme_card.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onBack;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
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
          'APP SETTINGS',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 15,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsHeaderTile(
              icon: Icons.palette_rounded,
              title: 'APPEARANCE & THEME',
            ),
            SettingsThemeCard(
              isDarkMode: isDark,
              onToggleTheme: onToggleTheme,
            ),
            const SizedBox(height: 12),
            const SettingsHeaderTile(
              icon: Icons.sd_storage_rounded,
              title: 'STORAGE & MEMORY',
            ),
            const SettingsStorageCard(),
            const SizedBox(height: 12),
            const SettingsHeaderTile(
              icon: Icons.info_rounded,
              title: 'CODEX VERSION',
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF101726) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF26334D) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hero Codex Engine',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'AFL 1 Release Build',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Text(
                    'v2.4.0',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFEAB308),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
